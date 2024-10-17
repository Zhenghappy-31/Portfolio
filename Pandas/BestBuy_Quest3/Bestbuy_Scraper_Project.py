import requests, time, datetime, smtplib, csv
from bs4 import BeautifulSoup

def check_Quest3_price():
    url = 'https://www.bestbuy.com/site/meta-quest-3-512gb-the-most-powerful-quest-ultimate-mixed-reality-experiences-get-batman-arkham-shadow-white/6596938.p?skuId=6596938'

    # get headers from httpbin.org/get
    User_Agent = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0"}
    page = requests.get(url,headers = User_Agent)
    soup = BeautifulSoup(page.text, 'html')
    title = soup.find('h1').text
    print(title)
    price = soup.find('div', class_ = "priceView-hero-price priceView-customer-price").text
    float_price = price[1:7]
    print(float_price)
    today = datetime.date.today()
    header = ['Title','Price','Date']
    table_data = [title,float_price,today]

    with open(r'D:\Pandas\BestBuy\Quest3_512GB.csv','a',newline='') as table_file:
        writer = csv.writer(table_file)
    # Only need the header once
    #    writer.writerow(header)
        writer.writerow(table_data)

while (True):
    check_Quest3_price()
    time.sleep(60*60*24)