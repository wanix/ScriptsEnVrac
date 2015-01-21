#!/usr/bin/python
###############################################################################
## Script : test_seo.py
## Author : Erwan SEITE
## Aim : tests SEO for redirect rules
## Licence : GPL v2
## Source : https://github.com/wanix/myTestLab
###############################################################################

# CSV example in input 
# -----------------------------------------------------------------------------
# URL to test; expected http code; expected URL in response
# http://yahoo.com;301;https://www.yahoo.com/
# http://amazon.com;301;http://www.amazon.com/
# -----------------------------------------------------------------------------
#

# Cookie file example
# -----------------------------------------------------------------------------
# language=french
# country=france
# -----------------------------------------------------------------------------

import requests
import argparse
import csv

##########
# Parsing args
##########
parser = argparse.ArgumentParser(description="Verify redirects from list of URLs")
parser.add_argument("-t", "--testfile", required=True, type=argparse.FileType('r'), help="input file of tests to do (see format inside the script)")
parser.add_argument("-c", "--cookie", nargs='?', type=argparse.FileType('r'), help="cookie file (see format inside de script)")
parser.add_argument("-v", "--verbose", action="store_true", help="be verbose")
parser.add_argument("-f", "--follow", action="store_true", help="follow redirects to compare the last result ? (default no)")
args = parser.parse_args()
##########

##########
# Preparating cookies, format key=value line by line in file
##########
cookies = {}
if args.cookie:
  for line in args.cookie.readlines():
    (key,value)=line.strip().split('=')
    cookies[key] = value

if cookies and args.verbose:
  print "cookie transmited : " + str(cookies)

##########
# Lecture du fichier
##########
reader = csv.reader(args.testfile,delimiter=';')
rownum=0
NBerrors=0
for row in reader:
  errorfound=False
  rownum += 1
  #We jump the title line
  if rownum == 1:
    continue

#For each lines, we have:
  # URL to test; expected http code; expected URL in response
  (url, resultcode, resultstring) = row
  try:
    url = url.strip()
    resultstring = resultstring.strip()
    r = requests.get(url, allow_redirects=args.follow,cookies=cookies)
    if r.status_code != int(resultcode):
      errorfound=True
      print "Error : incorrect code "+str(r.status_code)+" (especting "+str(resultcode)+") for "+url
    if r.status_code == 301 or r.status_code == 302:
      compare_url=r.headers['location']
    else:
      compare_url=r.url
    if compare_url != resultstring:
      errorfound=True
      print "Error : sent     - "+url
      print "        received - "+compare_url
      print "        espected - "+resultstring
  except requests.ConnectionError:
      print "Error : failed to connect : "+url
      errorfound=True
      NBerrors += 1
  if errorfound:
    NBerrors += 1
  elif args.verbose:
    print "OK : sent     - "+url
    print "     received - "+compare_url+" ("+str(r.status_code)+")"
#end for row in reader:

NBTests=rownum - 1
NBTestsOK = NBTests - NBerrors
if NBerrors == 0:
  print "All "+str(NBTests)+" test(s) OK."
else:
  print str(NBTestsOK)+" test(s) OK, "+str(NBerrors)+"/"+str(NBTests)+" in error."
