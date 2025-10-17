# Geocoding with OpenRefine & the GeoLocate API

#### Using the GeoLocate Community Server API to geocode esoteric text-based location descriptions with uncertainty estimates

## About This Guide

This tutorial demonstrates how to use OpenRefine with the GeoLocate Community Server API to geocode location data that contains textual place descriptions rather than structured street addresses. The GeoLocate API is particularly well-suited for historical, museum, and natural history collections data where locations are described in narrative form, such as "5 miles west of Springfield along Route 66" or "near the confluence of the Green and Colorado Rivers."

Unlike standard address geocoding services, GeoLocate provides **uncertainty values** that estimate the geographic extent of ambiguity in the location description. This makes it invaluable for geocoding older spatial location information associated with 19th and 20th century fieldwork in biology, archaeology, geology, natural history, and other fields where precise coordinates were not originally recorded.

## About the Dataset

For this exercise, we'll use the **California Haunted Places** dataset (`ca_haunted_places.csv`), which contains location descriptions of reportedly haunted locations across California. This dataset is ideal for demonstrating GeoLocate's capabilities because:

- Locations are described in natural language rather than structured addresses
- Many descriptions reference landmarks, relative directions, and distances
- Location precision varies widely across records
- Some locations are historical and may no longer exist

You can view the dataset here: [ca_haunted_places.csv](Data/ca_haunted_places.csv)

### Dataset Fields

The dataset includes:

- **location**: Text description of the haunted location
- **city**: City name
- **state**: State name
- **state_abbrev**: State abbreviation
- **description**: Full narrative description of the haunting
- **longitude/latitude**: Pre-existing coordinates (we'll compare our results to these)

## Getting Ready

### Download the Data

Download the California Haunted Places dataset:

[ca_haunted_places.csv](Data/ca_haunted_places.csv)

### Download and Install OpenRefine

If you haven't already, download and install OpenRefine:

[https://openrefine.org/download](https://openrefine.org/download)

OpenRefine is open-source software that allows you to manipulate and augment data. It runs in your browser but operates locally on your machine. For this exercise, OpenRefine will help us submit URLs to the GeoLocate API repeatedly for all our records, saving us from manual copy-and-paste work.

## What is the GeoLocate API?

The GeoLocate Community Server is a web-based geocoding service developed specifically for natural history collections and research data. Unlike standard geocoding services that expect street addresses, GeoLocate:

- Interprets natural language locality descriptions
- Handles relative distances and directions ("5 km NE of...")
- Works with historical place names and geographic features
- Provides **uncertainty radius** estimates for each geocoded point
- Returns geographic extent polygons showing possible location areas

The GeoLocate API is freely available for educational and research use through their Community Server.

### Understanding Uncertainty in Geocoding

One of GeoLocate's most valuable features is its calculation of **uncertainty radius** values. When geocoding historical or textual location data, we rarely have absolute precision. Consider these examples:

- "Near San Francisco" - Could be anywhere within 10-50 miles
- "5 miles north of the Golden Gate Bridge" - More precise, but "5 miles" could mean 4.5-5.5 miles
- "123 Main Street, San Jose, CA" - Very precise, uncertainty might be 10-100 meters

GeoLocate quantifies this uncertainty by providing:

- **Uncertainty Radius**: Distance in meters representing the possible error
- **Uncertainty Polygon**: The geographic area within which the true location likely falls

This is crucial for:

- **Historical specimen data**: Museum records from the 1800s-1900s with vague locations
- **Archaeological sites**: "Near the old mill, south of town"
- **Geological surveys**: "Outcrop along the river, 2 miles upstream from bridge"
- **Biological field notes**: "Oak grove on hillside above valley floor"

## Building Your Template Query

The GeoLocate API endpoint for the Community Server is:

`https://www.geo-locate.org/webservices/geolocatesvcv2/glcwrap.aspx`

Let's build a test query using one record from our haunted places dataset.

### Example Location Description

Let's use the first record from our dataset:

- **Location**: "Ada Cemetery"
- **City**: "Ada"
- **State**: "Michigan"

### Constructing the URL

The GeoLocate API uses these key parameters:

- `locality`: The location description text
- `state`: State name or abbreviation
- `country`: Country name
- `fmt`: Output format (we'll use `json`)

A complete query URL looks like this:

```
https://www.geo-locate.org/webservices/geolocatesvcv2/glcwrap.aspx?locality=Ada+Cemetery&state=Michigan&country=United+States&fmt=json
```

### Test the Query

1. Copy the URL above into your web browser
2. Press Enter to submit the query
3. You should receive JSON-formatted results

The response will look something like this:

```json
{
"engineVersion" : "GLC:9.3|U:1.01374|eng:1.0",
"numResults" : 1,
"executionTimems" : 171.8821,
"resultSet" : { "type": "FeatureCollection",
"features": [
{ "type": "Feature",
"geometry": {"type": "Point", "coordinates": [-85.504733, 42.962303]},
"properties": {
"parsePattern" : "ADA CEMETERY",
"precision" : "High",
"score" : 87,
"uncertaintyRadiusMeters" : "Unavailable",
"uncertaintyPolygon" : "Unavailable",
"displacedDistanceMiles" : 0,
"displacedHeadingDegrees" : 0,
"debug" : ":GazPartMatch=False|:inAdm=True|:Adm=KENT|:NP=ADA CEMETERY|:KFID=|ADA CEMETERY"
}
}
 ],
"crs": { "type" : "EPSG", "properties" : { "code" : 4326 }}
}
}
```

### Key Response Fields

- **engineVersion** — API engine/version string
  JSON path: `engineVersion`
- **numResults** — Number of results returned (integer)
  JSON path: `numResults`
- **executionTimems** — Query execution time in milliseconds (number)
  JSON path: `executionTimems`
- **resultSet.type** — Typically `"FeatureCollection"` (GeoJSON wrapper)
  JSON path: `resultSet.type`
- **resultSet.features** — Array of Feature objects; usually use the first feature (`features[0]`)
  JSON path: `resultSet.features[0]`
- **coordinates** — Point coordinates as [longitude, latitude] (x, y)
  JSON path: `resultSet.features[0].geometry.coordinates`
  Note: longitude = coordinates[0], latitude = coordinates[1]
- **parsePattern** — How GeoLocate parsed/normalized the locality string (often uppercase)
  JSON path: `resultSet.features[0].properties.parsePattern`
- **precision** — Quality rating (e.g., High, Medium, Low)
  JSON path: `resultSet.features[0].properties.precision`
- **score** — Confidence score (0–100)
  JSON path: `resultSet.features[0].properties.score`
- **uncertaintyRadiusMeters** — Estimated error radius in meters, or the string `"Unavailable"` when not provided
  JSON path: `resultSet.features[0].properties.uncertaintyRadiusMeters`
- **uncertaintyPolygon** — WKT polygon describing the uncertainty area, or `"Unavailable"`
  JSON path: `resultSet.features[0].properties.uncertaintyPolygon`
- **displacedDistanceMiles** — Distance the returned point was displaced from the original interpreted location (miles)
  JSON path: `resultSet.features[0].properties.displacedDistanceMiles`
- **displacedHeadingDegrees** — Heading (degrees) for any displacement applied to the point
  JSON path: `resultSet.features[0].properties.displacedHeadingDegrees`
- **debug** — Internal parse/debug string useful for troubleshooting matches
  JSON path: `resultSet.features[0].properties.debug`
- **crs** — Coordinate reference system object (e.g., EPSG:4326)
  JSON path: `resultSet.crs`

#### Examples for using GREL in OpenRefine for access (first feature):

- Longitude: `value.parseJson().resultSet.features[0].geometry.coordinates[0]`
- Latitude:  `value.parseJson().resultSet.features[0].geometry.coordinates[1]`
- Uncertainty: `value.parseJson().resultSet.features[0].properties.uncertaintyRadiusMeters`
- Parse pattern: `value.parseJson().resultSet.features[0].properties.parsePattern`
- Score: `value.parseJson().resultSet.features[0].properties.score`
- Debug: `value.parseJson().resultSet.features[0].properties.debug`

## Setting Up OpenRefine

### Import the Data

1. Launch OpenRefine (it will open in your browser at http://127.0.0.1:3333)
2. Click **Create Project**
3. Choose **This Computer** and browse to `ca_haunted_places.csv`
4. Click **Next**
5. Review the data preview and click **Create Project**

### Examine the Data

Look at the **location**, **city**, and **state** columns. Notice how locations vary:

- Some are specific: "Ada Cemetery"
- Some are vague: "North Adams Rd."
- Some include directions: "Gorman Rd. west towards Sand Creek"
- Some reference landmarks: "Ghost Trestle"

This variability makes GeoLocate ideal for this dataset.

## Creating the API Call in OpenRefine

### Step 1: Build the Base URL

We need to construct a URL that combines:

- The GeoLocate API endpoint
- Our location data from the **location** column
- Our city data from the **city** column
- Our state data from the **state** column

### Step 2: Add a Column by Fetching URLs

1. Click on the dropdown arrow next to the **location** column
2. Select **Edit column** > **Add column by fetching URLs...**
3. Name the new column: `geolocate_json`

### Step 3: Create the Expression

In the Expression box, enter:

```
"https://www.geo-locate.org/webservices/geolocatesvcv2/glcwrap.aspx?locality=" + 
escape(cells["location"].value, "url") + 
"&state=" + escape(cells["state"].value, "url") + 
"&country=United+States&fmt=json"
```

This expression:

- Starts with the base GeoLocate API URL
- Adds the **locality** parameter using the location column value
- Adds the **state** parameter using the state column value
- Adds a fixed country parameter
- Requests JSON format output
- Uses `escape()` to properly encode special characters for URLs

### Step 4: Configure Throttling

**Important**: Set the **Throttle delay** to at least **200 milliseconds** (0.2 seconds). This prevents overwhelming the GeoLocate server with requests.

### Step 5: Run the Fetch

Click **OK** and OpenRefine will:

- Build a custom URL for each row
- Submit each URL to the GeoLocate API
- Store the JSON response in the new `geolocate_json` column

This may take several minutes depending on the size of your dataset.

## Parsing the JSON Response

Now we need to extract useful information from the JSON responses.

### Extract Longitude

1. Click the dropdown on **geolocate_json** column
2. Select **Edit column** > **Add column based on this column**
3. Name it: `longitude`
4. Use this expression:

```
value.parseJson().resultSet.features[0].geometry.coordinates[0]
```

### Extract Latitude

1. Click the dropdown on **geolocate_json** column
2. Select **Edit column** > **Add column based on this column**
3. Name it: `latitude`
4. Use this expression:

```
value.parseJson().resultSet.features[0].geometry.coordinates[1]
```

### Extract Uncertainty Radius

1. Click the dropdown on **geolocate_json** column
2. Select **Edit column** > **Add column based on this column**
3. Name it: `uncertainty_meters`
4. Use this expression:

```
value.parseJson().resultSet.features[0].properties.uncertaintyRadiusMeters
```

### Extract Precision Level

1. Click the dropdown on **geolocate_json** column
2. Select **Edit column** > **Add column based on this column**
3. Name it: `precision`
4. Use this expression:

```
value.parseJson().resultSet.features[0].properties.precision
```

### Extract Match Score

1. Click the dropdown on **geolocate_json** column
2. Select **Edit column** > **Add column based on this column**
3. Name it: `score`
4. Use this expression:

```
value.parseJson().resultSet.features[0].properties.score
```

## Interpreting Results

### Understanding Uncertainty Values

Look at your new **uncertainty_meters** column. You'll see values ranging from small (high precision) to large (low precision):

- **< 100 meters**: Very precise, specific address or landmark
- **100-1000 meters**: Good precision, named place or feature
- **1000-5000 meters**: Moderate precision, general area
- **> 5000 meters**: Low precision, vague description

### Understanding Precision Levels

The **precision** column shows:

- **High**: Specific, well-defined location
- **Medium**: Reasonably well-defined location with some ambiguity
- **Low**: Vague or ambiguous location description

### Understanding Match Scores

The **score** column (0-100) indicates confidence:

- **90-100**: Excellent match
- **80-89**: Good match
- **70-79**: Fair match
- **< 70**: Poor match, review manually

## Comparing Results

If your original dataset had coordinates (like our haunted places data), you can compare:

1. Create a column to calculate distance between original and GeoLocate coordinates
2. Identify records with large discrepancies
3. Use uncertainty values to understand if differences are within expected error

### Calculate Distance Difference

Add a column with this expression (approximate):

```
abs(cells["longitude"].value - value.parseJson().resultSet.features[0].geometry.coordinates[0]) * 111000
```

This gives a rough east-west distance in meters.

## Filtering and Quality Control

### Filter by Precision

Use OpenRefine's faceting to filter results:

1. Click dropdown on **precision** column
2. Select **Facet** > **Text facet**
3. Review counts of High/Medium/Low precision matches
4. Filter to show only low precision matches for manual review

### Filter by Uncertainty

1. Click dropdown on **uncertainty_meters** column
2. Select **Facet** > **Numeric facet**
3. Adjust the slider to focus on high uncertainty records
4. Review these records manually

### Filter by Score

1. Click dropdown on **score** column
2. Select **Facet** > **Numeric facet**
3. Focus on scores below 80 for review

## Handling Failed Geocodes

Some records may fail to geocode. To identify them:

1. Click dropdown on **longitude** column
2. Select **Facet** > **Customized facets** > **Facet by blank**
3. Review records that returned no coordinates

Common reasons for failure:

- Location name not found in GeoLocate's database
- Description too vague or ambiguous
- Typos or incorrect place names
- Historical names no longer recognized

### Manual Review Strategies

For failed or low-quality geocodes:

1. Check the original **location** and **city** fields
2. Try simplifying the location description
3. Use just the city name if location is too obscure
4. Consider alternative geocoding services for specific addresses

## Exporting Your Results

Once satisfied with your geocoding results:

1. Click **Export** in the top-right corner
2. Choose your format:
   - **Comma-separated values (CSV)**: For spreadsheets
   - **Tab-separated values (TSV)**: For import to GIS software
   - **Excel**: For Microsoft Excel
3. Save your enriched dataset

## Use Cases for GeoLocate with Historical Data

### Museum Collections

Natural history museums have millions of specimen records with locality descriptions like:

- "Collected 5 miles east of Yosemite Valley, 1892"
- "Along the Merced River below Vernal Falls"
- "Oak woodland, west slope Sierra Nevada"

GeoLocate interprets these descriptions and provides realistic uncertainty estimates, allowing researchers to:

- Map historical species distributions
- Track environmental change over time
- Identify sampling gaps in collections

### Archaeological Records

Archaeological site descriptions often use landmarks and relative positions:

- "Midden site on bluff overlooking river confluence"
- "Rock shelter 2 km upstream from bridge"
- "Burial mound complex, south of old mission"

The uncertainty radii help researchers:

- Plan survey areas for site relocations
- Assess site density and clustering
- Protect site locations while sharing data

### Geological Surveys

Historical geology field notes contain descriptions like:

- "Limestone outcrop along creek, 1.5 miles below dam"
- "Coal seam exposed in railroad cut near tunnel"
- "Fault scarp crossing valley floor east of town"

Uncertainty values help geologists:

- Revisit historical sample locations
- Integrate historical and modern datasets
- Assess data quality for different uses

## Best Practices

### Prepare Your Data

1. **Clean location descriptions**: Remove excess punctuation and formatting
2. **Standardize state/country names**: Use full names or standard abbreviations
3. **Separate address components**: If you have them, use separate fields for better results

### Optimize API Calls

1. **Use appropriate throttle delays**: Don't overwhelm the server
2. **Cache results**: Save the JSON responses to avoid re-geocoding
3. **Batch large datasets**: Process in smaller chunks if needed

### Document Your Process

Record:

- Date of geocoding
- GeoLocate API version (if available)
- Any manual corrections made
- Criteria for accepting/rejecting matches
- How uncertainty values were used in analysis

### Validate Results

1. **Spot check**: Manually verify a sample of geocoded locations
2. **Use uncertainty values**: Assess if precision meets your needs
3. **Compare to existing coordinates**: If available
4. **Map results**: Visual inspection often reveals errors

## Advanced Techniques

### Extracting Uncertainty Polygons

GeoLocate returns uncertainty polygons in WKT (Well-Known Text) format. To extract:

```
value.parseJson().resultSet.features[0].properties.uncertaintyPolygon
```

These polygons can be imported into GIS software for spatial analysis.

### Combining Multiple Geocoding Services

For best results, consider:

1. Try GeoLocate first for natural language descriptions
2. Fall back to address geocoders for structured addresses
3. Use different services for different location types

### Handling International Locations

For locations outside the US:

- Specify the correct country parameter
- Be aware that GeoLocate coverage varies by country
- Consider regional geocoding services for better results

## Troubleshooting

### No Results Returned

**Problem**: JSON response is empty or contains no features

**Solutions**:

- Simplify location description
- Check spelling of place names
- Try using only city and state
- Verify country is correct

### High Uncertainty Values

**Problem**: Uncertainty radius is very large (>10,000 meters)

**Solutions**:

- Add more specific location details if available
- Accept the uncertainty if description is inherently vague
- Consider whether precision meets your research needs
- Flag for manual research

### API Rate Limiting

**Problem**: Requests are being blocked or timing out

**Solutions**:

- Increase throttle delay in OpenRefine
- Process data in smaller batches
- Contact GeoLocate for higher rate limits if needed
- Spread processing over multiple sessions

### Parse Errors in OpenRefine

**Problem**: Expression returns errors or null values

**Solutions**:

- Check JSON structure has expected format
- Add null-checking to expressions: `if(value != null, ...)`
- Verify API responses are complete
- Review OpenRefine expression syntax

## Additional Resources

### Documentation

- [GeoLocate Web Services Documentation](https://www.geo-locate.org/web-services/)
- [OpenRefine User Manual](https://docs.openrefine.org/)
- [Understanding Georeferencing](https://docs.gbif.org/georeferencing-best-practices/)

### Related Tools

- **GEOLocate Desktop**: Standalone application with visual verification
- **QGIS**: For mapping and analyzing geocoded results
- **GeoPick**: For collaborative georeferencing projects

### Community Resources

- [iDigBio Georeferencing Community](https://www.idigbio.org/content/georeferencing)
- [TDWG Georeferencing Best Practices](https://github.com/tdwg/prior-standards/blob/master/georeferencing-best-practices/)

### Support

- For GeoLocate questions: Contact through [geo-locate.org](https://www.geo-locate.org/)
- For OpenRefine help: [OpenRefine Community Forum](https://forum.openrefine.org/)

---

[← Back to Geocoding 101 Introduction](README.md)

*Tutorial prepared by the Stanford Geospatial Center*
