#!/usr/bin/python3

import whois
from datetime import datetime


def get_cn(whois_cn):
    domain_info = {}
    domain_info["域名"] = whois_cn.domain_name
    domain_info["注册时间"] = str(whois_cn.creation_date)
    domain_info["到期时间"] = str(whois_cn.expiration_date)
    domain_info["注册用户"] = whois_cn.name
    domain_info["注册邮箱"] = whois_cn.emails
    domain_info["注册商"] = whois_cn.registrar
    return domain_info


def get_info(whois_info):
    domain_info = {}
    domain_info["域名"] = whois_info.domain_name
    if isinstance(whois_info.creation_date, list):
        domain_info["注册时间"] = str(whois_info.creation_date[0])
    else:
        domain_info["注册时间"] = str(whois_info.creation_date)

    if isinstance(whois_info.expiration_date, list):
        domain_info["到期时间"] = str(whois_info.expiration_date[0])
    else:
        domain_info["到期时间"] = str(whois_info.expiration_date)
    if whois_info.org:
        domain_info["注册组织"] = whois_info.org
    if whois_info.country and whois_info.state:
        domain_info["注册地址"] = whois_info.country + whois_info.state
    domain_info["注册邮箱"] = whois_info.emails
    domain_info["注册商"] = whois_info.registrar
    return domain_info


def cal_days(expiration_date):
    """
    计算还有多少天过期
    """
    now = datetime.now()
    expiration = datetime.strptime(str(expiration_date), "%Y-%m-%d %H:%M:%S")
    return (expiration - now).days


if __name__ == "__main__":
    domains = ["ip.cn", "baidu.com"]
    for domain in domains:
        w = whois.whois(domain)
        if domain.split(".")[-1] == "cn":
            whois_info = get_cn(w)
            print(whois_info)
        else:
            whois_info = get_info(w)
            print(whois_info)

