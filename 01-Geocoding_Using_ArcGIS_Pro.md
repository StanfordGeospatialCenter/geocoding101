# Geocoding Using ArcGIS Pro (with clowns.csv)

This guide walks you through a complete geocoding workflow in ArcGIS Pro using the Stanford Geospatial Center's [locator.stanford.edu](http://locator.stanford.edu) geocoding services and the `clowns.csv` dataset. You'll learn how to start ArcGIS Pro, log in to Stanford's ArcGIS Online, connect to the locator, import your CSV to a geodatabase, fix ZIP codes with dropped leading zeros, and geocode your data.

## Prerequisites

- ArcGIS Pro installed (on your computer or in the Stanford Geospatial Center Lab)
- Stanford University credentials
- Access to [stanford.maps.arcgis.com](https://stanford.maps.arcgis.com)
- The `clowns.csv` dataset (located in the `Data/` folder)

**Important:** The locator.stanford.edu services are IP-restricted to the Stanford Network. If you cannot connect, ensure you are using the Stanford AnyConnect VPN. For VPN help, visit [Stanford IT VPN documentation](https://uit.stanford.edu/service/vpn).

## Step 1: Start ArcGIS Pro and Log In

1. Launch **ArcGIS Pro**.
2. When prompted, sign in with your Stanford credentials to [stanford.maps.arcgis.com](https://stanford.maps.arcgis.com).

![](images/20251016_103211_image.png)

![](images/20251016_103236_image.png)

![](images/20251016_103252_image.png)

## Step 2: Connect to the Stanford Locator Service

1. In ArcGIS Pro, Start a New Project, with Catalog

![](images/20251016_103412_image.png)

![](images/20251016_103518_image.png)

1. go to the **Insert** tab.
2. Click **Connections** > **Server** > **New ArcGIS Server**.

![](images/20251016_103616_image.png)

1. For **Server URL**, enter: `https://locator.stanford.edu/arcgis`
2. Leave authentication blank and click **OK**.

![](images/20251016_103728_image.png)

1. In the **Catalog** pane, expand **Servers>arcgis on locator.stanford.edu.ags>geocode>** and locate the Stanford regional locator services.

![](images/20251016_103859_image.png)

1. Right-click the **USA** locator and select **Add To Project**. The locator will appear in your **Locators** folder.

![](images/20251016_103948_image.png)

#### Note on ArcGIS World Geocoding Service

*When you open ArcGIS Pro, you will see the **ArcGIS World Geocoding Service** listed by default in the Locators pane (see image below). This service is available to all Stanford users, but **it consumes ArcGIS Online credits for each geocoding transaction**. While it is suitable for small geocoding jobs, for any project involving more than a few thousand records, you should use the Stanford Geospatial Center's locator at **locator.stanford.edu** to avoid unnecessary credit usage and ensure support for research-scale geocoding.*

Begin by downloading the `clowns.csv` dataset and saving it to an easy-to-find folder on your hard drive (for example: `C:\Users\<you>\Documents\Geocoding\Data\` on Windows or `~/Documents/Geocoding/Data/` on macOS/Linux). Create the folder if necessary.

## Adding a new Folder Connection to ArcGIS Pro

**Note**: ArcGIS Pro does not automatically create connections to local directories. You must explicitly add a folder connection for each project (Catalog pane → Project > Folders → Add Folder Connection or click the folder icon ► Add Folder Connection). Adding the connection makes files like clowns.csv visible to ArcGIS Pro and available to geoprocessing tools; folder connections are saved in the project (.aprx) and may need to be recreated when opening the project on another machine.

1. In ArcGIS Pro, open the **Catalog** pane.
2. Under **Project > Folders**, right-click and choose **Add Folder Connection** (or click the folder icon ► **Add Folder Connection**) and browse to the folder where you saved `clowns.csv`. This makes the file easy to find from within ArcGIS Pro.


![](images/20251016_154651_image.png)

1. In the **Catalog** pane, expand the newly added folder and confirm `clowns.csv` is visible.
5. Right-click `clowns.csv` and select **Add To Current Map** (or **Create Table** if prompted).
6. To enable geocoding, right-click the resulting table and choose **Export** > **Table To Geodatabase**.
7. Select your project geodatabase as the destination and click **OK**.
8. In the **Catalog** pane, browse to the `clowns.csv` file in the `Data/` folder.
9. Right-click `clowns.csv` and select **Add to Current Map** (or **Create Table** if prompted).
10. To enable geocoding, right-click the table and choose **Export** > **Table To Geodatabase**.
11. Select your project geodatabase as the destination and click **OK**.

## Step 4: Fix ZIP Codes with Dropped Leading Zeros

**Note:** Spreadsheet software may drop leading zeros from ZIP codes, turning `01234` into `1234`.

To restore ZIP codes:

1. Open the attribute table for your imported data.
2. Click **Add Field** to create a new field:
   - Name: `ZIP_str`
   - Type: **Text (String)**
   - Length: 5
   - Save the new field.
3. Click **Calculate Field** for `ZIP_str`.
4. In the calculation dialog:
   - Select records where `ZIP` < 10000 (these are missing a leading zero).
   - For these, set `ZIP_str = '0' + str(!ZIP!)`
   - Flip the selection (select records where `ZIP` >= 10000).
   - For these, set `ZIP_str = str(!ZIP!)`
5. Save your edits. Now all ZIP codes are correctly formatted as 5-digit strings.

## Step 5: Geocode Your Data

1. Open the **Geocode Table** tool (Analysis > Tools > Search for "Geocode Table").
2. Set your geodatabase table as the **Input Table**.
3. Choose the appropriate Stanford locator service as the **Input Address Locator**.
4. Map your address fields (including `ZIP_str` for ZIP code).
5. Set the **Output Feature Class** location.
6. Click **Run** to geocode your data.

## Step 6: Review Results

- The output feature class will be added to your map.
- Check the attribute table for match status and scores.
- Unmatched records may need further cleaning or manual review.

## Additional Geocoding Tips and Best Practices

- Always check for formatting issues after importing data from spreadsheets.
- Document your workflow for reproducibility.
- For help, contact [stacemaples@stanford.edu](mailto:stacemaples@stanford.edu).
- For large datasets, consider breaking into smaller batches and running during off-peak hours.
- Do not use the Stanford locator service with PHI or high-risk data.

## Troubleshooting

- If you cannot connect to locator.stanford.edu, verify VPN/network status and server URL.
- Low match rates? Review data quality, field mapping, and locator choice.
- Service unavailable? Check [stanfordgis mailing list](https://mailman.stanford.edu/mailman/listinfo/stanfordgis) or contact support.

## Resources

- [Esri's Geocoding Documentation for ArcGIS Pro](https://pro.arcgis.com/en/pro-app/latest/help/data/geocoding/what-is-geocoding.htm)
- [Stanford Geospatial Center](https://library.stanford.edu/research/stanford-geospatial-center)

---

[← Back to Geocoding 101 Introduction](README.md)

*Tutorial prepared by the Stanford Geospatial Center*
