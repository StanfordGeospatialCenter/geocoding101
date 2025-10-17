# Geocoding 101: An Introduction for Research Data Preparation

Slides: [https://slides.com/staceymaples/geocoding-101](https://slides.com/staceymaples/geocoding-101)  

This Guide is published on Github Pages at: [https://stanfordgeospatialcenter.github.io/geocoding101/](https://stanfordgeospatialcenter.github.io/geocoding101/)

## Code Examples

* [Python Batch Geocoding Notebook](Code/locator_batch_address_geocode_rest.ipynb)
* [R Geocoding Script](Code/locator_address_geocode.R)
* [JSON to GeoJSON Conversion](Code/locator_json_to_geojson_address_geocode_rest.ipynb)

## Sample Data

* [199 Addresses Dataset](Data/199Addresses.csv)
* [California Haunted Places](Data/ca_haunted_places.csv)
* [Clowns Business Locations](Data/clowns.csv)
* [Santa Clara Tattoo Parlors](Data/SantaClara_TattooParlors.csv)
* [Geocoded 199 Addresses (Sample Output)](Data/geocoded_199Addresses.csv)

## Additional Resources

* [Locator Service Information](locatorinfo.html)
* [GeoLocate JSON Documentation](glcJSON.pdf)

## What is Geocoding?

Geocoding is the process of transforming location descriptions—such as street addresses, place names, or administrative boundaries—into geographic coordinates (latitude and longitude). This transformation is fundamental to spatial analysis, allowing researchers to map, visualize, and analyze location-based data across disciplines including public health, social sciences, history, environmental studies, and more.

In the context of research data preparation, geocoding serves as a critical bridge between textual location information and spatial analysis. Once locations are converted to coordinates, researchers can:

- **Map and visualize** data to identify spatial patterns and trends
- **Extract values** from other spatial datasets (e.g., climate data, demographic information, elevation)
- **Measure proximity** to features and phenomena (e.g., distance to hospitals, schools, or environmental hazards)
- **Perform spatial joins** to combine datasets based on location
- **Conduct spatial statistical analyses** to test hypotheses about geographic relationships

Geocoding relies on reference datasets—such as street networks, administrative boundaries, gazetteers (place name databases), and points of interest—to match input locations to their corresponding coordinates. The quality and coverage of these reference datasets directly impact the accuracy and success rate of geocoding operations.

## Types of Geocoding

Different research questions require different types of geocoding. Understanding these types helps researchers choose the appropriate method and evaluate the quality of their results.

### Address Geocoding

Address geocoding converts street addresses into coordinates, typically with high precision (rooftop or street-level accuracy). This is one of the most common geocoding tasks in research.

**Use Cases:**

- Mapping patient addresses for health studies (with appropriate privacy protections)
- Analyzing customer or business locations
- Studying residential patterns and neighborhood characteristics
- Historical address research

**Considerations:**

- Address formats vary by country and region
- Accuracy depends on the completeness and currency of reference street data
- Address standardization and cleaning often necessary before geocoding
- Privacy concerns must be addressed when working with residential addresses

### Place Name Geocoding

Place name (or toponym) geocoding converts named locations—such as cities, landmarks, neighborhoods, or natural features—into coordinates. This typically returns a representative point for the named feature.

**Use Cases:**

- Geocoding historical place names from archives or texts
- Mapping event locations from news reports or social media
- Analyzing place mentions in literature or documents
- Studying geographic distributions of cultural or historical phenomena

**Considerations:**

- Place names can be ambiguous (e.g., "Springfield" exists in many states)
- Historical place names may have changed or no longer exist
- Returned coordinates are usually centroids, not precise locations
- Different gazetteers may have different coverage and accuracy

### Administrative Geocoding

Administrative geocoding converts administrative unit names (countries, states, counties, postal codes, etc.) into representative coordinates, typically the centroid of the area.

**Use Cases:**

- Mapping aggregated data reported by administrative units
- Joining datasets based on administrative geography
- Analyzing regional patterns and comparisons
- Creating choropleth maps

**Considerations:**

- Returns centroid points, not boundaries (separate boundary data needed for polygon mapping)
- Administrative boundaries change over time
- Hierarchical specificity matters (city vs. county vs. state)
- Census and other official data often align with administrative units

### Reverse Geocoding

Reverse geocoding works in the opposite direction: it takes coordinates and returns information about the nearest feature, such as an address, place name, or administrative unit.

**Use Cases:**

- Converting GPS coordinates to readable addresses
- Identifying locations from coordinate data
- Enriching coordinate-only datasets with contextual information
- Quality checking geocoding results

**Considerations:**

- Returns nearest match, which may not be the exact location
- Useful for validating forward geocoding results
- Can help identify what type of feature a coordinate represents

### Point of Interest (POI) Geocoding

POI geocoding locates specific types of places such as businesses, landmarks, facilities, or services by name or category.

**Use Cases:**

- Mapping hospital, school, or park locations
- Analyzing access to services and amenities
- Studying commercial or institutional distributions
- Creating proximity measures to specific facility types

**Considerations:**

- POI databases vary in coverage and currency
- Business locations change frequently
- May require category codes or filters for searches
- Useful for measuring accessibility and spatial equity

### Batch vs. Interactive Geocoding

Geocoding can be performed either interactively (one location at a time) or in batch mode (processing many locations simultaneously):

- **Interactive geocoding** is useful for small numbers of locations or when human review is needed
- **Batch geocoding** is essential for research datasets containing hundreds, thousands, or millions of records

Research applications typically require batch geocoding capabilities to efficiently process large datasets while maintaining data quality and reproducibility.

## Geocoding Quality and Match Accuracy

Geocoding quality varies based on:

- **Match rate**: The percentage of input records successfully geocoded
- **Match accuracy**: How precisely the returned coordinates represent the intended location
- **Match score/confidence**: Numerical indicators of geocoding confidence
- **Match type**: Whether the match was to an address, street segment, postal code, city, etc.

High-quality research requires attention to these metrics and often involves:

- Cleaning and standardizing input data
- Reviewing and manually correcting low-confidence matches
- Documenting geocoding methods and match rates
- Considering the appropriate level of precision for the research question

## About the Stanford Locator Service

The Stanford Geospatial Center provides [locator.stanford.edu](http://locator.stanford.edu), a geocoding service designed specifically for research applications and data augmentation. This service supports several types of geocoding operations:

- **Address geocoding** for US locations and international addresses
- **Place name geocoding** across multiple continents
- **Administrative unit geocoding** for various geographic levels
- **Reverse geocoding** to convert coordinates back to location information

The service provides global coverage with region-specific datasets for North America, Latin America, Europe, Asia Pacific, and Africa/Middle East. It is designed for bulk geocoding operations, making it suitable for processing research datasets ranging from thousands to millions of records.

For Stanford researchers, the locator service offers a secure, privacy-conscious platform for geocoding sensitive research data, with all communication encrypted and no logging of geocoding requests.

**Note on Data Privacy**: When geocoding research data, especially data involving human subjects, researchers must consider privacy and ethical implications. Geocoding can make data more identifiable, so appropriate protections must be in place. The Stanford locator service should not be used with Protected Health Information (PHI) or other high-risk data. Consult your IRB for guidance on data de-identification and privacy policies.

## Next Steps

This guide provides a conceptual foundation for geocoding in research contexts. For technical details on:

- Connecting to and using the Stanford locator service
- Geocoding workflows in specific tools (ArcGIS Pro, R, Python)
- API access and programmatic geocoding
- Best practices for data preparation and quality control

Please refer to the additional documentation and tutorials provided by the Stanford Geospatial Center.

## Additional Resources

- [Esri's Introduction to Geocoding](https://pro.arcgis.com/en/pro-app/latest/help/data/geocoding/what-is-geocoding.htm)
- Stanford Geospatial Center: [https://library.stanford.edu/research/stanford-geospatial-center](https://library.stanford.edu/research/stanford-geospatial-center)
- For questions or support: [stacemaples@stanford.edu](mailto:stacemaples@stanford.edu)

---

*Resources for geocoding in research, provided by the Stanford Geospatial Center*
