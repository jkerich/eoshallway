#! /usr/local/bin/python3
import xml.etree.ElementTree as ET  
import httplib2
from urllib import request, error
from xml.sax.saxutils import unescape,escape
import re
import os
import time
import lxml.etree

#globals
trmmPageURL = "http://trmm.gsfc.nasa.gov"

h = httplib2.Http('.cache')

#trmm
response, content = h.request(trmmPageURL)
s = content.decode("UTF-8")

sloppyParser = lxml.etree.HTMLParser(recover=True) #assume html is bad
pageHTML = lxml.etree.fromstring(content,sloppyParser)

#print(lxml.etree.tostring(pageHTML,pretty_print=True))
print(s)

