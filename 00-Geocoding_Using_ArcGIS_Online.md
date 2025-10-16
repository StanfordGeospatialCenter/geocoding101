
# Geocoding with ArcGIS Online: Santa Clara Tattoo Parlors Example

This guide will walk you through the process of geocoding a business dataset using ArcGIS Online, with a focus on the Santa Clara Tattoo Parlors data. You'll learn how to upload, prepare, and geocode a CSV file, and how to review and use the resulting map.

## About the Dataset

The dataset for this exercise is `SantaClara_TattooParlors.csv`, which contains business information for tattoo parlors in Santa Clara County, California. Each row represents a business and includes fields such as:

- Company Name
- Business Name
- Street Address
- City
- State Abbreviation
- Zip Code
- Telephone Number
- Line of Business
- NAICS/SIC codes
- Sales Volume, Employees, Year Started

You can view or download the dataset here:

- [SantaClara_TattooParlors.csv](Data/SantaClara_TattooParlors.csv)

**Note:** Some ZIP codes may have lost leading zeros if the file was previously opened in spreadsheet software. See the data preparation section for how to address this.

---

## Step 1: Sign in to ArcGIS Online
1. Go to [https://stanford.maps.arcgis.com](https://stanford.maps.arcgis.com) in your web browser.
2. Click **Sign In** and use your Stanford credentials.

## Step 2: Add the Tattoo Parlor CSV to Your Content
1. In the top menu, click **Content**.
2. Click **New item** > **Your device**.
3. Browse to and select `SantaClara_TattooParlors.csv` from your local computer.
4. Click **Next** and review the detected fields.
5. Set the location fields:
	- **Location type:** Addresses or Places
	- **Address field:** `Street Address`
	- **City field:** `City`
	- **State field:** `State Abbreviation`
	- **ZIP Code field:** `Zip Code`
6. Click **Next** and review the map preview.
7. Click **Next** and provide a title, tags, and folder location for your new hosted feature layer.
8. Click **Save** to upload and publish the data.

## Step 3: Prepare the Data (Fix ZIP Codes if Needed)
If you notice that some ZIP codes are missing leading zeros (e.g., `95112` is correct, but `95008` appears as `5008`), you can fix this in ArcGIS Online:

1. Open the hosted feature layer you just created.
2. Click the **Data** tab to view the table.
3. Click **Fields** and add a new field:
	- Name: `ZIP_str`
	- Type: **String**
	- Length: 5
4. Return to the **Table** view.
5. Use the **Calculate** tool to populate `ZIP_str`:
	- For records where `Zip Code` < 10000, set `ZIP_str` to `0` + `Zip Code`.
	- For records where `Zip Code` >= 10000, set `ZIP_str` to `Zip Code` as a string.
6. Use the new `ZIP_str` field for mapping and analysis.

## Step 4: Geocode and Map the Data
If you uploaded the CSV as an address table, ArcGIS Online will automatically attempt to geocode the records and display them on the map.

1. Open the hosted feature layer in **Map Viewer**.
2. Review the points on the map for accuracy.
3. If any records failed to geocode, check the address fields and correct as needed in the table, then re-run the geocoding process.

## Step 5: Save and Share Your Map
1. In the Map Viewer, click **Save and open** > **Save as** to save your map.
2. Add a title, tags, and summary.
3. To share your map, click **Share** and choose the appropriate sharing settings (e.g., Stanford, public, or specific groups).

## Tips and Best Practices
- Always check for formatting issues after importing data from spreadsheets.
- Use string fields for ZIP codes to preserve leading zeros.
- Document your workflow for reproducibility.
- For help, contact [stacemaples@stanford.edu](mailto:stacemaples@stanford.edu).

---

[← Back to Geocoding 101 Introduction](README.md)

*Tutorial prepared by the Stanford Geospatial Center*

