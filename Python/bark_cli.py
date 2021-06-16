#!/usr/bin/python3

import os
import sys
import requests
from dataclasses import dataclass
from argparse import ArgumentParser


@dataclass
class Bark():
    request_scheme: str
    request_host: str
    request_port: int
    bark_key: str
    bark_title: str
    bark_body: str
    bark_group: str
    bark_automatically_copy: int
    bark_copy: str
    bark_url: str
    bark_archive: int
    bark_sound: str

    def send_message(self):
        url: str = f'{self.request_scheme}://{self.request_host}:{self.request_port}/{self.bark_key}/'
        payload: dict = {"title": self.bark_title,
                         "body": self.bark_body}
        params: dict = {"automaticallyCopy": self.bark_automatically_copy,
                        "copy": self.bark_copy, "url": self.bark_url,
                        "isArchive": self.bark_archive, "sound": self.bark_sound,
                        "group": self.bark_group}
        try:
            response = requests.post(url, data=payload, params=params).json()
            return response.get('code', 400)
        except Exception as e:
            print(e)
            return 400


def main():
    parser = ArgumentParser(description='Bark CLI', prog='bark_cli')
    parser.add_argument('-s', '--scheme', type=str, default='https',
                        choices=['http', 'https'], help='Bark Server Scheme, default=https',
                        dest='request_scheme')
    parser.add_argument('-u', '--host', type=str, default='api.day.app',
                        help='Bark Server Host, default=api.day.app', dest='request_host')
    parser.add_argument('-p', '--port', type=int, default=443,
                        help='Bark Server Port, default=443', dest='request_port')
    parser.add_argument('-k', '--key', type=str,  dest='bark_key',
                        help='Bark Key, INPUT or ENV(BARK_KEY)')
    parser.add_argument('-t', '--title', type=str, default='',
                        help='Bark Message Title', dest='bark_title')
    parser.add_argument('-b', '--body', type=str, required=True,
                        help='Bark Message Body', dest='bark_body')
    parser.add_argument('--group', type=str, default='default',
                        help='Bark Message Group', dest='bark_group')
    parser.add_argument('--autocopy', type=int, default=0, choices=[0, 1],
                        help='Bark Parameter Automatically Copy, default=0',
                        dest='bark_automatically_copy')
    parser.add_argument('--copy', type=str, default='',
                        help='Bark Parameter Copy', dest='bark_copy')
    parser.add_argument('--url', type=str, default='',
                        help='Bark Parameter URL', dest='bark_url')
    parser.add_argument('--archive', type=int, default=1, choices=[0, 1],
                        help='Bark Parameter Archive, default=1', dest='bark_archive')
    parser.add_argument('--sound', type=str, default='silence', dest='bark_sound',
                        help='Bark Parameter Sound, default=silence',)
    # choices=['alarm', 'anticipate', 'bell',
    #         'birdsong', 'bloom', 'calypso', 'chime', 'choo', 'descent', 'electronic',
    #         'fanfare', 'glass', 'gotosleep', 'healthnotification', 'horn', 'ladder',
    #         'mailsent', 'minuet', 'multiwayinvitation', 'newmail', 'newsflash', 'noir',
    #         'paymentsuccess', 'shake', 'sherwoodforest', 'silence', 'spell', 'suspense',
    #         'telegraph', 'tiptoes', 'typewriters', 'update'])
    args = parser.parse_args()

    bark_key = args.bark_key if args.bark_key else os.environ.get('BARK_KEY')
    if not bark_key:
        sys.exit('Need Bark Key.')

    bark = Bark(request_scheme=args.request_scheme, request_host=args.request_host,
                request_port=args.request_port, bark_key=bark_key, bark_title=args.bark_title,
                bark_body=args.bark_body, bark_group=args.bark_group,
                bark_automatically_copy=args.bark_automatically_copy, bark_copy=args.bark_copy,
                bark_url=args.bark_url, bark_archive=args.bark_archive, bark_sound=args.bark_sound)
    if bark.send_message() == 200:
        print('Send Succeed!')
    else:
        print('Send Failed!')


if __name__ == '__main__':
    main()

