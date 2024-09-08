# Amazon Deal Finder - Python Web Scraping project

This project involves scraping product details from Amazon, monitoring prices, and sending email notifications when prices fall below user-defined thresholds. The process stops once all target prices are met.

## Tools and Libraries

The **Amazon Price Tracker** project uses the following tools and libraries, and was developed in a Jupyter Notebook environment:

- **`requests`**: For fetching HTML content from product URLs.
- **`BeautifulSoup`**: For parsing and extracting data from HTML.
- **`pandas`**: For managing and storing data in CSV files.
- **`smtplib`**: For sending email notifications when price thresholds are met.
- **`os`**: For checking file existence and managing file operations.


## 1. Taking User Inputs

- **URLs of Products**: Users input a comma-separated list of product URLs to track.
- **Minimum Prices**: Users specify minimum price thresholds for receiving notifications.
- **Interval for Checking Prices**: Users define how often (in seconds) the script should check for price updates.

```python
list_of_urls = input('Kindly enter the list of URLs you want to track (comma separated): ').split(',')
minimum_prices = input('Please enter the minimum prices of the items at which you\'d like to receive email notifications (comma separated): ').split(',')
interval = int(input('Please specify the regular interval at which the price should be retrieved and checked (in seconds): '))
```
## 2. Scraping Product Data

- **Fetch HTML Content**: Use `requests` to retrieve the HTML content of each product URL.

- **Parse HTML**:
  - **Prettify HTML**: Convert the HTML into a more readable format for easier extraction.
    ```python
    soup1 = BeautifulSoup(page.content, 'html.parser')
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    ```
  - **Extract Data**:
    - **By ID**: Locate the product title using the HTML `id` attribute.
      ```python
      title = soup2.find(id="productTitle").get_text().strip()
      ```
    - **By Class**: Locate the product price using the HTML `class` attribute.
      ```python
      price = soup2.find(class_='a-price-whole').get_text().strip()
      ```
    - **Get Text**: Extract text content from HTML elements.
    - **Strip**: Remove any leading or trailing whitespace from the text.

- **Handling Date and Time**:
  - **Get Current Date and Time**:
    ```python
    today = str(datetime.datetime.now())
    ```
  - **Remove Time Factor**: Remove the time portion from the date string for consistency.
    ```python
    today = today[:today.find('.')]
    ```

## 3. Storing Data in CSV File

- **File Creation and Data Writing**:
  - **Check File Existence**: If the CSV file does not exist, create it and write the header and initial data.
    ```python
    if not os.path.exists("AmazonWebScrapData.csv"):
        with open("AmazonWebScrapData.csv", 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(title1)  # Header row
            writer.writerow(data)    # Initial data row
    ```
  - **Appending Data**: If the file exists, append new data to the existing file.
    ```python
    with open("AmazonWebScrapData.csv", 'a+', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(data)  # Append new data row
    ```
## 4. Sending Email Notifications

- **Email Configuration**: Set up the SMTP server settings to send emails.

- **Compose and Send Email**:
  - **Subject and Body**: Craft the email subject and body with product details and a link to the product.
  - **Send Email**: Use `smtplib` to send the email notification.

  ```python
  def send_mail(title, price):
      server = smtplib.SMTP("smtp.gmail.com", 587)
      server.starttls()
      server.login('your-email@gmail.com', 'your-password')
      
      subject = f"This is your {title} that you want is now available at Rs {price}. Now is your chance to buy!"
      body = f"Kunal, This is the moment we have been waiting for. Now is your chance to pick up the {title}. Don't mess it up! Link here: [Product Link]"
      
      msg = f"Subject: {subject}\n\n{body}"
      
      server.sendmail('your-email@gmail.com', 'recipient-email@gmail.com', msg)
      server.quit()
## 5. Handling Price Thresholds and URLs

- **Price Check**:
  - **Compare Price**: Check if the fetched price is below or equal to the user-defined minimum price.
    ```python
    if int(price.replace(',', '')) <= int(minimum_prices[i]):
        no_of_items.append(i)
        send_mail(title, price)
    ```

- **Remove Processed Items**:
  - **Update Lists**: Remove URLs and minimum prices for items that have met the price condition to prevent further checks.
    ```python
    for i in sorted(no_of_items_satified, reverse=True):
        minimum_prices.pop(i)
        list_of_urls.pop(i)
    ```
  - **Sorted Reverse**: Use `sorted(reverse=True)` to handle multiple removals in reverse order. This prevents index errors when removing items from lists.

- **Stopping the Process**:
  - **Terminate When All Items Are Processed**: Continue checking prices at the defined interval until all target prices are met and both `minimum_prices` and `list_of_urls` are empty.
    ```python
    if len(minimum_prices) == 0 and len(list_of_urls) == 0:
        break
    ```
## 6. Continuous Monitoring and Execution

- **Infinite Loop**:
  - **Price Checking**: The script runs in an infinite loop, continuously checking the prices of products at the specified interval.
    ```python
    while True:
        no_of_items_satified = check_price(list_of_urls, minimum_prices)
        time.sleep(interval)
    ```

- **Update Lists**:
  - **Process and Remove**: If items have met their price conditions, remove them from the tracking lists.
    ```python
    if len(no_of_items_satified) > 0:
        for i in sorted(no_of_items_satified, reverse=True):
            minimum_prices.pop(i)
            list_of_urls.pop(i)
    ```

- **Termination Condition**:
  - **Exit Loop**: The script stops running when all specified price thresholds are met and there are no more items left to track.
    ```python
    if len(minimum_prices) == 0 and len(list_of_urls) == 0:
        break
    ```
## 7. Handling Data Encoding Issues

- **Read CSV File with Specific Encoding**:
  - **Handling Encoding Errors**: When reading the CSV file, use the appropriate encoding to handle any potential UnicodeDecodeErrors. In this case, `ISO-8859-1` is used to read the file.
    ```python
    import pandas as pd
    
    df = pd.read_csv(r"C:\Users\hp\Desktop\Data science\Portfolio Projects\Amazon Web Scrapping Project Python\AmazonWebScrapData.csv", encoding='ISO-8859-1')
    df
    ```

## Summary

In summary, the **Amazon Deal Finder** project provides an efficient solution for monitoring price changes on Amazon. By automating data retrieval, price comparison, and notifications, it helps users stay informed about product deals and ensures they never miss an opportunity to purchase at the best price. The integration of continuous monitoring and real-time alerts makes this tool a valuable asset for savvy shoppers looking to optimize their purchases.
