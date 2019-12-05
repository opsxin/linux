#!/usr/bin/python3

import os
import shutil
import tarfile

from datetime import datetime, timedelta

dt = datetime.now()
ydt = dt.today() + timedelta(-1)
lm = (datetime.now().replace(day=1) + timedelta(-1))

date_day = dt.strftime('%d')
date_year_month = dt.strftime('%Y-%m')
date_yesterday = ydt.strftime('%Y-%m-%d')
last_month = lm.strftime('%Y-%m')


def get_logs(path):
    """
    查找目录下的所有 .log 文件，不包括子目录。
    """
    logs = []
    for file in os.listdir(path):
        if os.path.splitext(file)[-1] == ".log":
            logs.append(file)
    return logs


def move_log(source_path, backed_path, date):
    os.chdir(source_path)
    backed_path = os.path.join(backed_path, date)
    if not os.path.exists(backed_path):
        os.makedirs(backed_path)

    for log in get_logs(source_path):
        target_file = "%s/%s_%s" \
            % (backed_path, log, date_yesterday)
        shutil.copy2(log, target_file)
        with open(log, "w") as f:
            f.truncate()


def tar_logs(backed_path, remove_path=False):
    os.chdir(backed_path)
    tar_name = "%s.tgz" % (last_month)
    with tarfile.open(tar_name, "w:gz") as tar:
        tar.add(last_month)
    if remove_path:
        shutil.rmtree(last_month)
    os.mkdir(date_year_month)


if __name__ == "__main__":
    jars_path = ["/tmp/test1", "/tmp/test2"]
    for jar_path in jars_path:
        backed_log_path = os.path.join(jar_path, "backed_logs")

        if date_day == "01":
            move_log(jar_path, backed_log_path, last_month)
            tar_logs(backed_log_path, False)
        else:
            move_log(jar_path, backed_log_path, date_year_month)

