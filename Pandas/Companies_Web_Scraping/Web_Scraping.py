from bs4 import BeautifulSoup
import requests
import pandas

#connect with webpage, and get html for the first table.
url = "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
page = requests.get(url)
soup = BeautifulSoup(page.text,'html')
table = soup.find_all('table')[0]

#get table headers
headers = table.find_all('th')
table_header = [th.text.strip() for th in headers]
df = pandas.DataFrame(columns=table_header)

#get table data and insert into dataframe
table_rows = table.find_all('tr')[1:]
for row in table_rows:
    table_datas = row.find_all('td')
    table_data = [td.text.strip() for td in table_datas]
    column_length = len(df)
    df.loc[column_length] = table_data

#print table
print(df)

#save table as csv file without index
df.to_csv(r'D:\Pandas\Web_Scraping\Companies.csv', index=False)