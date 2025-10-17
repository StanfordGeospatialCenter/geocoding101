# Geocoding with Python: Using the locator.stanford.edu REST API

This guide introduces you to programmatic geocoding using Python and the Stanford Geospatial Center's locator service REST API. Unlike the graphical interfaces in ArcGIS Pro or ArcGIS Online, this approach uses Python code to submit address data directly to the geocoding service and process the results.

## What is the REST API?

REST (Representational State Transfer) API is a web service that allows programs to communicate over HTTP—the same protocol your web browser uses. The locator.stanford.edu service provides a REST API that accepts address data and returns geocoded coordinates in a structured format (JSON).

**Key advantages of using the REST API:**
- **Automation**: Process thousands or millions of addresses without manual intervention
- **Reproducibility**: Your geocoding workflow is documented in code
- **Flexibility**: Customize how you handle inputs, outputs, and errors
- **Integration**: Easily incorporate geocoding into larger data processing pipelines
- **Batch Processing**: Submit multiple addresses in a single request for efficiency

## Network Requirements

**Important**: The locator.stanford.edu services are **IP-restricted to the Stanford Network**. This means:

- ✅ **Works**: On-campus computers, Stanford WiFi, Stanford VPN (AnyConnect)
- ❌ **Does NOT work**: Cloud services like Google Colab, Jupyter Hub, or other external hosting

If you're using cloud-based Python environments (Colab, Jupyter Hub, AWS, etc.), the geocoding requests will fail because these services run outside the Stanford IP range. For this exercise, you must run the Python notebook either:
- On a Stanford computer (lab, personal laptop on campus)
- Through Stanford VPN (AnyConnect)
- On a personal computer connected to Stanford WiFi

## Understanding the GeocodeAddresses Endpoint

The locator service provides several geocoding endpoints. For batch geocoding (multiple addresses at once), we use the **GeocodeAddresses** endpoint:

```
https://locator.stanford.edu/arcgis/rest/services/geocode/USA/GeocodeServer/geocodeAddresses
```

This endpoint accepts:
- **Input**: A batch of up to 1,000 addresses in a structured JSON format
- **Output**: Geocoded coordinates and match quality information for each address

### Available Regional Services

Different regional services are optimized for specific geographic areas:

- **USA**: `https://locator.stanford.edu/arcgis/rest/services/geocode/USA/GeocodeServer/geocodeAddresses`
- **North America**: `https://locator.stanford.edu/arcgis/rest/services/geocode/NorthAmerica/GeocodeServer/geocodeAddresses`
- **Latin America**: `https://locator.stanford.edu/arcgis/rest/services/geocode/LatinAmerica/GeocodeServer/geocodeAddresses`
- **Europe**: `https://locator.stanford.edu/arcgis/rest/services/geocode/Europe/GeocodeServer/geocodeAddresses`
- **Asia Pacific**: `https://locator.stanford.edu/arcgis/rest/services/geocode/AsiaPacific/GeocodeServer/geocodeAddresses`
- **Africa/Middle East**: `https://locator.stanford.edu/arcgis/rest/services/geocode/MiddleEastAfrica/GeocodeServer/geocodeAddresses`

Choose the service that matches your data's geographic region for best results.

## Key Concepts in Batch Geocoding

### 1. Request Structure

When geocoding with the REST API, you structure your data as JSON records. Each address includes fields like:
- `Address`: Street address
- `City`: City name
- `Region`: State or province
- `Postal`: ZIP or postal code
- `CountryCode`: Country identifier

The API expects these records in a specific format that tells the geocoding service how to interpret your data.

### 2. Batch Processing

Rather than geocoding one address at a time, batch processing submits multiple addresses together:
- **Efficiency**: Fewer HTTP requests = faster overall processing
- **Server-friendly**: Reduces load on the geocoding service
- **Recommended size**: 100-1,000 addresses per batch

The Python notebook demonstrates how to split a large dataset into appropriate batch sizes.

### 3. Response Handling

The geocoding service returns JSON responses containing:
- **Coordinates**: Latitude and longitude for each address
- **Match Score**: Confidence level (0-100) in the geocode quality
- **Match Type**: Type of match (address point, street segment, postal code, etc.)
- **Standardized Address**: How the service interpreted your input

Your Python code must parse this JSON to extract the information you need.

### 4. Progress Tracking and Error Handling

When processing large datasets, the Python notebook includes:
- **Progress reporting**: Shows how many records are processed and time remaining
- **Error handling**: Catches and reports failed requests without stopping the entire job
- **Resumable processing**: Appends results as they complete, so you can stop and restart
- **Statistics**: Final summary of processing speed and success rate

## The Batch Geocoding Workflow

The Python notebook implements this workflow:

1. **Read Input Data**: Load addresses from a CSV file
2. **Prepare Batches**: Split addresses into chunks of appropriate size
3. **Format Requests**: Structure each batch according to API requirements
4. **Submit to API**: Send HTTP POST requests to the geocoding service
5. **Parse Responses**: Extract coordinates and match information from JSON
6. **Write Results**: Append geocoded data to output CSV file
7. **Report Progress**: Update user on status and estimated completion time

## Input Data Requirements

Your input CSV file must have columns matching the geocoding service's expected fields:

- `Address`: Street number and name
- `City`: City name
- `Region`: State/province (e.g., "CA" or "California")
- `Postal`: ZIP/postal code
- `CountryCode`: Optional, especially for US addresses

Example CSV structure:
```csv
Address,City,Region,Postal
450 Serra Mall,Stanford,CA,94305
1600 Amphitheatre Parkway,Mountain View,CA,94043
```

The notebook includes examples using datasets from the repository's Data folder:
- `199Addresses.csv` - Small test dataset (199 records)
- `clowns.csv` - Business locations
- `SantaClara_TattooParlors.csv` - Tattoo parlor addresses
- `oneMillionAddresses.csv` - Large-scale testing dataset

## Output Data

The geocoding process creates a new CSV file with:
- **All original fields**: Your input data is preserved
- **Coordinates**: X (longitude) and Y (latitude) values
- **Match information**: Score, address type, status
- **Standardized address**: How the geocoder interpreted the location

This enriched dataset can then be:
- Imported into GIS software for mapping
- Used for spatial analysis
- Combined with other geographic datasets
- Visualized on web maps

## Python Notebook Exercise

The complete batch geocoding workflow is implemented in the Jupyter Notebook:

**[locator_batch_address_geocode_rest.ipynb](Code/locator_batch_address_geocode_rest.ipynb)**

This notebook provides:
- **Detailed explanations**: Each code section is documented for learners
- **Configurable parameters**: Easy-to-adjust settings for your data
- **Progress monitoring**: Real-time updates during processing
- **Error handling**: Robust processing of large datasets
- **Reusable code**: Function you can adapt for your own projects

### What You'll Learn

By working through the notebook, you'll understand:
- How to structure HTTP requests to the geocoding API
- How to work with JSON data in Python
- How to process large datasets in batches
- How to parse API responses and extract needed information
- How to write results to CSV files
- How to monitor and report on long-running processes

### Prerequisites

To use the notebook, you need:
- **Python 3.x** installed on your computer
- **Jupyter Notebook** or **JupyterLab** (or use VS Code with Jupyter extension)
- **requests library**: Install with `pip install requests`
- **Stanford Network access**: On-campus, WiFi, or VPN connection
- **A CSV file** with addresses to geocode (or use provided sample data)

### Getting Started

1. **Download the notebook**: [locator_batch_address_geocode_rest.ipynb](Code/locator_batch_address_geocode_rest.ipynb)
2. **Connect to Stanford Network**: Use VPN if off-campus
3. **Open in Jupyter**: Launch the notebook in your Jupyter environment
4. **Configure parameters**: Set your input/output file paths and batch sizes
5. **Run the cells**: Execute the notebook cells in order
6. **Monitor progress**: Watch the progress updates as geocoding proceeds
7. **Review results**: Check your output CSV file for geocoded data

## Python vs. Other Geocoding Methods

### When to Use Python Geocoding

✅ **Best for:**
- Large datasets (thousands to millions of addresses)
- Automated, recurring geocoding tasks
- Integration with data processing pipelines
- Custom error handling and quality control
- Research workflows requiring reproducibility

### When to Use Other Methods

**ArcGIS Pro** is better for:
- Interactive geocoding with visual review
- Small to medium datasets
- When you need immediate visual feedback
- Integration with other ArcGIS workflows

**ArcGIS Online** is better for:
- Quick, one-time geocoding jobs
- Sharing geocoded data on web maps
- Collaborative projects
- When you don't have ArcGIS Pro installed

**OpenRefine** is better for:
- Data cleaning combined with geocoding
- Working with messy or inconsistent address data
- When you need to try different geocoding services
- Visual inspection and correction of results

## Advanced Topics

Once comfortable with the basic notebook, you can explore:

### Custom Field Mapping

Adapt the code to work with differently-structured CSV files by mapping your column names to the required API fields.

### Quality Filtering

Add logic to filter results based on match scores, excluding low-quality geocodes for manual review.

### Multi-Region Geocoding

Modify the workflow to automatically select the appropriate regional service based on country codes in your data.

### Rate Limiting and Throttling

Implement delays between requests to be respectful of the geocoding service, especially for very large datasets.

### Integration with GIS Libraries

Combine geocoding with libraries like `geopandas` to immediately create spatial datasets and perform geographic analysis.

## Troubleshooting

### Connection Errors

**Problem**: "Connection refused" or timeout errors

**Solutions**:
- Verify you're connected to Stanford Network or VPN
- Test the service URL in your web browser first
- Check that the endpoint URL is correct

### JSON Parsing Errors

**Problem**: Error reading or parsing JSON responses

**Solutions**:
- Print the raw response to inspect its structure
- Check that your request format matches API requirements
- Verify the API hasn't changed its response format

### Low Match Rates

**Problem**: Many addresses return low scores or fail to geocode

**Solutions**:
- Review your address data for formatting issues
- Check that fields are mapped correctly
- Verify you're using the appropriate regional service
- Consider data cleaning before geocoding

### Performance Issues

**Problem**: Geocoding is very slow

**Solutions**:
- Increase batch size (up to 1,000 addresses)
- Reduce unnecessary fields in requests
- Check your network connection speed
- Run during off-peak hours if processing very large datasets

## Privacy and Data Considerations

Remember:
- **Do not geocode PHI** (Protected Health Information)
- **Consult your IRB** for research involving human subjects
- **No logging**: The locator service doesn't retain your requests
- **Secure transmission**: All communication uses HTTPS encryption

## Additional Resources

### Documentation

- [ArcGIS REST API Reference](https://developers.arcgis.com/rest/services-reference/enterprise/geocode-service.htm)
- [Python requests library](https://requests.readthedocs.io/)
- [Working with JSON in Python](https://docs.python.org/3/library/json.html)

### Related Tutorials

- [Geocoding with ArcGIS Pro](01-Geocoding_Using_ArcGIS_Pro.md)
- [Geocoding with ArcGIS Online](00-Geocoding_Using_ArcGIS_Online.md)
- [Geocoding with OpenRefine](02-Geocoding_Using_OpenRefine.md)
- [Other Geocoding Services](04-Other_Geocoding_Services.md)

### Support

- **Stanford Geospatial Center**: [https://library.stanford.edu/research/stanford-geospatial-center](https://library.stanford.edu/research/stanford-geospatial-center)
- **Email Support**: [stacemaples@stanford.edu](mailto:stacemaples@stanford.edu)
- **Mailing List**: [stanfordgis@lists.stanford.edu](https://mailman.stanford.edu/mailman/listinfo/stanfordgis)

---

[← Back to Geocoding 101 Introduction](README.md) | [Open Python Notebook →](Code/locator_batch_address_geocode_rest.ipynb)

*Tutorial prepared by the Stanford Geospatial Center*
