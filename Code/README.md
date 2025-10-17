# Locator.stanford.edu Geocoding Scripts for Python or R

## Overview

This directory contains scripts and data for batch geocoding large lists of addresses using the [Stanford ArcGIS Locator Service](https://locator.stanford.edu/). The primary workflow reads a CSV of addresses, sends them in batches to the Stanford ArcGIS REST API, and writes the geocoded results to a new CSV file. The scripts are designed for efficiency and robustness with large datasets.

---

## About locator.stanford.edu

The [Stanford ArcGIS Locator Service](https://locator.stanford.edu/) provides geocoding capabilities for North America and the USA via a REST API. It allows users to submit addresses and receive geographic coordinates and address components in return. The service supports batch geocoding (multiple addresses per request) and returns detailed match information for each address.

- **API Documentation:** [ArcGIS REST API: geocodeAddresses](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-geocode-addresses.htm)
- **Batch Limit:** Up to 1000 addresses per request.
- **Required Fields:** Typically `Address`, `City`, `Region` (State), `Postal`, and `CountryCode`.

---

## Repository Content

### Data Files

- **Data/oneMillionAddresses.csv**  
  A large CSV file containing addresses to be geocoded.  
  **Columns:**  
  - `OBJECTID`: Unique identifier for each address  
  - `Address`: Street address  
  - `Postal`: ZIP code  
  - (Other columns may be present but are not required by the geocoder)

- **Data/199Addresses.csv**  
  A smaller CSV file with 199 address records, useful for testing or demonstration of the geocoding workflow.  
  **Columns:**  
  - Same as above (`OBJECTID`, `Address`, `Postal`, etc.)


---

### Code Files

## **locator_geocode_Script.R**  
  Main R script for batch geocoding.  
  **Features:**  
  - Reads input CSV of addresses.
  - Ensures required columns for the locator service.
  - Sends addresses in user-configurable batch sizes to the ArcGIS REST API.
  - Handles API responses and extracts geocoding results.
  - Writes results to a CSV file.
  - Prints progress summaries, elapsed time, estimated time to completion, and a final summary.

  **Key Parameters:**  
  - `service_url`: API endpoint for the Stanford locator.
  - `csv_file_path`: Path to the input addresses CSV.
  - `output_csv_file`: Path for the geocoded output.
  - `chunk_size`: Number of addresses per batch.
  - `job_size`: How many records to process (`"all"` or an integer).

  **Usage:**  
  1. Edit the user-configurable parameters at the top of the script.
  2. Run the script in R.
  3. Monitor progress and find results in the specified output CSV.

## **locator_batch_geocode_rest.ipynb**  
  Jupyter Notebook for batch geocoding using the Stanford ArcGIS Locator REST API.  
  **Features:**  
  - Step-by-step workflow for reading address CSVs, submitting batches to the API, and writing results.
  - Heavily commented and beginner-friendly, with markdown explanations for each step.
  - Progress reporting, error handling, and final statistics.
  - Parameters for input/output file paths, batch size, and API endpoint are easily configurable in notebook cells.
  - Suitable for interactive exploration and demonstration.

## **locator_json_to_geojson_address_geocode_rest.ipynb**  
  Jupyter Notebook for converting ArcGIS geocoding JSON results to GeoJSON format.  
  **Features:**  
  - Reads JSON output from the ArcGIS geocoding service.
  - Transforms the results into standard GeoJSON for use in GIS applications or mapping tools.
  - Useful for spatial analysis, visualization, or further processing of geocoded data.

---

## Notes

- The scripts and notebooks are designed for beginning users and are heavily commented.
- The Stanford Locator API requires a Stanford network connection or VPN.
- For large jobs, adjust `chunk_size` and `job_size` as needed.
- Output CSV columns may vary depending on the locator's response.
- The notebooks provide interactive, step-by-step workflows and are suitable for demonstration or teaching.

---


