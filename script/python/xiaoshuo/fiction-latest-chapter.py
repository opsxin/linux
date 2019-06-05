#!/usr/bin/python3

import os
import re
import requests
from bs4 import BeautifulSoup
from configparser import ConfigParser

DIRNAME = os.path.dirname(os.path.abspath(__name__))
# Server酱
WECHAT = "https://sc.ftqq.com/"
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
HEADERS = {'user-agent': USER_AGENT, 'Accept-Language': 'zh-CN,zh;q=0.9', 'Referer': 'http://www.huanyue123.com/book/top.html'}

# 自定义method异常
class methodException(Exception):
    def __init__(self, mesg="raise methodException"):
        print(mesg)

# requests请求
def get_html(url, method="get", my_data="{}"):
    if(method == "get"):
        html_doc = requests.get(url, headers=HEADERS)
        return str(html_doc.content, "gbk")
    elif(method == "post"):
        html_doc = requests.post(url, headers=HEADERS, data=my_data)
        return html_doc.status_code
    else:
        raise methodException("只支持get，post")

# 获取网络最新章节，并和本地对比
def get_latest_essay(url, lastest_essay):
    html_doc = get_html(url)
    pattern = '最新章节：</span><a href="(.*?)">(.*?)</a>'
    essay_name = re.search(pattern, html_doc).group(2)
    if (lastest_essay == essay_name):
#        print("当前章节已经为最新")
        return 0, essay_name
    else:
        return url + re.search(pattern, html_doc).group(1), essay_name

# 获取最新正文内容
def get_latest_content(url):
    content = get_html(url)
    soup = BeautifulSoup(content, "lxml")
    text = soup.find("div" ,id="htmlContent")
    content = re.sub(r'<.*>', '', str(text))
    return content

if __name__ == '__main__':
    cfg = ConfigParser()
    cfg.read(DIRNAME + '/latest-essay.cfg')
    for option in cfg.options("latest"):
        URL = cfg.get("URL", option)
        lastest_essay = cfg.get("latest", option)
        data, essay_name = get_latest_essay(URL, lastest_essay)
        if(data == 0):
            pass
        else:
            content = get_latest_content(data)
            code = get_html(WECHAT, "post", {'text': essay_name, 'desp': content})
            if(code == 200):
                cfg.set("latest", option, essay_name)
    cfg.write(open(DIRNAME + '/latest-essay.cfg', "w"))

