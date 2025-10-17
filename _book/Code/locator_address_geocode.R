# -----------------------------------------------------------------------------
#' Batch Geocode Addresses with ArcGIS REST API (Stanford Locator)
#'
#' This script reads a CSV file of addresses, sends them in batches to the
#' Stanford ArcGIS geocoding service, and writes the geocoded results to a new CSV.
#' It is designed for large address lists and handles batching, API requests,
#' and output formatting automatically.
# -----------------------------------------------------------------------------

# Load required libraries for HTTP requests, CSV reading/writing, and JSON handling
library(httr)      # For making HTTP requests to the API
library(readr)     # For reading and writing CSV files
library(jsonlite)  # For converting data to JSON format

# User-configurable parameters
service_url <- "https://locator.stanford.edu/arcgis/rest/services/geocode/USA/GeocodeServer/geocodeAddresses" # ArcGIS geocoding endpoint
csv_file_path <- "~/GitHub/Locator-Scripts/Data/oneMillionAddresses.csv" # Path to your input CSV file
output_csv_file <- "~/GitHub/Locator-Scripts/Data/geocoded_addresses01.csv" # Path for the output CSV file
chunk_size <- 10    # Number of addresses to send in each batch (API allows up to 1000)
job_size <- 100     # Set to "all" to process all records, or an integer for a subset

# Read the CSV file of addresses into a data frame
addresses <- read_csv(csv_file_path)

# Ensure the data frame has the required fields for the locator
# Add blank columns if missing, and select only the needed columns
if (!"City" %in% names(addresses)) addresses$City <- ""
if (!"Region" %in% names(addresses)) addresses$Region <- ""
if (!"CountryCode" %in% names(addresses)) addresses$CountryCode <- "USA"
addresses <- addresses[, c("OBJECTID", "Address", "City", "Region", "Postal", "CountryCode")]

# Helper function: Convert a data.frame of addresses to ArcGIS batch geocode records
make_records <- function(df) {
  # Each record is a list with an "attributes" element containing the address fields
  lapply(seq_len(nrow(df)), function(i) list(attributes = as.list(df[i, ])))
}

# Function to geocode a batch of addresses using the ArcGIS REST API
geocode_addresses <- function(batch_addresses, service_url) {
  payload <- list(
    f = "json",
    addresses = toJSON(list(records = make_records(batch_addresses)), auto_unbox = TRUE)
  )
  response <- POST(service_url, body = payload, encode = "form")
  if (response$status_code == 200) {
    content <- content(response, "parsed", simplifyVector = FALSE)
    # Only return locations, no printing
    if (!is.null(content$locations) && length(content$locations) > 0) {
      return(content$locations)
    } else {
      warning("No locations returned or unexpected response structure.")
      return(list())
    }
  } else {
    stop("Failed to geocode addresses")
  }
}

# Batch processing: Loop through the addresses in chunks and geocode each batch
results <- list()
start_time <- Sys.time() # Track start time
total_records <- if (job_size == "all") nrow(addresses) else min(as.numeric(job_size), nrow(addresses))
batches <- ceiling(total_records / chunk_size)

for (batch_num in seq_len(batches)) {
  i <- (batch_num - 1) * chunk_size + 1
  end <- min(i + chunk_size - 1, total_records)
  batch <- addresses[i:end, ]
  geocoded <- geocode_addresses(batch, service_url)
  if (length(geocoded) > 0) {
    results <- c(results, geocoded)
  }
  # Progress summary
  elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  processed <- end
  rate <- if (elapsed > 0) processed / elapsed * 3600 else NA
  est_total <- if (!is.na(rate) && rate > 0) total_records / (rate / 3600) else NA
  est_remaining <- if (!is.na(est_total)) est_total - elapsed else NA
  cat(sprintf("Processed %d of %d records (%.1f%%). Elapsed: %.1fs. ETA: %.1fs.\n",
              processed, total_records, 100 * processed / total_records, elapsed,
              ifelse(is.na(est_remaining), NA, est_remaining)))
  if (job_size != "all" && as.numeric(job_size) <= end) {
    break
  }
}

# Final summary
end_time <- Sys.time()
total_elapsed <- as.numeric(difftime(end_time, start_time, units = "secs"))
records_processed <- length(results)
records_per_hour <- if (total_elapsed > 0) records_processed / total_elapsed * 3600 else NA
cat(sprintf(
  "\nGeocoding complete. %d records processed in %.1f seconds (%.1f records/hour).\n",
  records_processed, total_elapsed, records_per_hour
))

# Write the geocoding results to a CSV file
if (length(results) > 0) {
  # Flatten results to a list of named vectors (attributes only)
  # This ensures each row in the output CSV corresponds to a geocoded address
  flat_results <- lapply(results, function(x) {
    attrs <- if (!is.null(x$attributes)) x$attributes else list()
    as.character(unlist(attrs))
  })
  # Collect all unique field names from the results for the CSV header
  all_fields <- unique(unlist(lapply(results, function(x) names(x$attributes))))
  # Build a data frame with all fields as columns, filling missing fields with NA
  results_df <- as.data.frame(do.call(rbind, lapply(results, function(x) {
    attrs <- if (!is.null(x$attributes)) x$attributes else list()
    sapply(all_fields, function(f) as.character(if (!is.null(attrs[[f]])) attrs[[f]] else NA), USE.NAMES = TRUE)
  })), stringsAsFactors = FALSE)
  # Write the data frame to CSV if it contains any rows and columns
  if (nrow(results_df) > 0 && ncol(results_df) > 0) {
    write_csv(results_df, output_csv_file)
    print("Geocoding completed.")
  } else {
    warning("No geocoding results to write (empty data frame after flattening).")
    print("Sample of 'results' object for debugging:")
    print(results)
  }
} else {
  warning("No geocoding results to write.")
}
