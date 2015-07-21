import sys
import requests

def main():
    url = sys.argv[1]
    tries = 0
    while tries < 6:
        print("Fetching {1}, try {0}".format(tries + 1, url))
        sys.stdout.flush()
        html = requests.get(url)
        if html.status_code == 200 and html.text:
            print("Succes!")
            sys.stdout.flush()
            redirfile = open('302file', 'w')
            redirfile.write(html.url)
            redirfile.close()
            break
        print("Received status code {0}, retrying to fetch url".format(html.status_code))
        sys.stdout.flush()
        tries = tries + 1
    if tries == 6:
        print("Exception fetching {0}".format(url))
        sys.stdout.flush()
        raise Exception
        

if __name__ == '__main__':
    main()
