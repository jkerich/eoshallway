#! /usr/local/bin/python3

import xml.etree.ElementTree as ET  
import httplib2
from urllib import request, error
from xml.sax.saxutils import unescape,escape
import re
import os
import time
import lxml.etree

#gloabl vars
xmlFile = 'feedinfo.xml'
feedURL = 'http://earthobservatory.nasa.gov/Feeds/rss/eo_iotd.rss'
mediaFolder = 'media'
imageFolder = 'img'
regFolder = 'reg'
largeFolder = 'large'
videoFolder = 'video'
firstRun = False
maxItems = 30

picTypes = [".jpeg",".png",".jpg",".tiff",".gif"]
vidTypes = [".mov",".avi",".mpeg"]

#TODO: write getEncoding function
#TODO: make download image more generic
#TODO: kmz are google earth files, make use of them in some way
"""------------------------- FUNCTIONS -------------------------"""

"""---------------------------------------------------------------
Name: writeimg
Purpose:
	Writes bytes to a file.
Params: 
	fname: name of the file to be created
	path: path to the directory to store the file
	bytes: binary information to be written as the file
Returns:
	void
Usage:
	writeimg("myfile.jpg","/path/to/directory",mybytes)
---------------------------------------------------------------"""
def writeimg(fname,path,bytes):
	#if image dir exists
	if not os.path.exists(path):
		os.makedirs(path)
	#image dir must exist before running script,'wb' means write-bytes	
	f = open(path+"/"+fname,"wb")
	f.write(bytes)
	f.close()
"""---------------------------------------------------------------
Name: downloadImage 
Purpose:
	Downloads an image from a provided image URL and sorts it into
	a specified folder.
Params: 
	url: URL to the image.
Requires:
	picTypes: list of acceptable picture file extensions
	vidTypes: list of acceptable video file extensions
	mediaFolder: main folder where all media is stored 
	imageFolder: name of folder that will contain all the images
	regFolder: name of folder that will contain the regular sized images from the nasa IOTD 
	largeFolder:name of folder that will contain the large sized images from the nasa IOTD  
	videoFolder: name of folder that will contain all videos from the nasa ITOD

Returns:
	sucess: True or False
	localpath: Local path to the downloaded file	

Usage:
	downloadImage("http://www.mysite.com/images/image01.jpg")
---------------------------------------------------------------"""
def downloadImage(url):
	#get filename
	filename = re.findall('([^/]+$)',url)[0]
	extension = os.path.splitext(filename)[1]
		
	#determine which folder to put in
	if extension in picTypes:
		dir = imageFolder
		if re.search("lrg"+extension,filename):
			dir = imageFolder + "/" + largeFolder
		else:
			dir = imageFolder + "/" + regFolder
	elif extension in vidTypes:
		dir = videoFolder
	else:
		print("DID NOT DOWNLOAD (bad file extension): " + filename)
		return False,""


	#attempt to open url to file
	print("OPENING: " + url + "...")
	response, content = h.request(url)

	if response.status == 200:
		writeimg(filename,mediaFolder+"/"+dir,content)
		print(filename + " WRITTEN")
		return True,mediaFolder+"/"+dir+"/"+filename
	else:
		print("DID NOT DOWNLOAD (unable to open url): " + url)
		return False,""

def getImages(linkURL): 
	linkURL = unescape(linkURL) #get rid of '&amp;amp' in xml
	#create xml node
	#media = ET.SubElement(item,"media")
	media = ET.Element("media")
	
	response, content = h.request(linkURL)
	s = content.decode('UTF-8')
	
	#capture image-info div
	exp = '<div class="image-info">(.*?)</div>'
	#search for large image within that
	for m in re.finditer(exp,s,re.DOTALL):
		exp = '<a href="([^"]+)"' #all content in image-info
		lrgimg = re.search(exp,m.group(0),re.DOTALL)
		if lrgimg:
			suc,lPath = downloadImage(lrgimg.group(1))
			if suc:
				ET.SubElement(media,"url",{"localpath":lPath}).text = lrgimg.group(1)
	

	#get regular images - these are pulled directly from the page
	exp = '<img src="(http://earthobservatory.nasa.gov[^"]+[^_tn]\.[a-zA-Z]+)"'
	for m in re.finditer(exp,s,re.DOTALL):
		suc,lPath = downloadImage(m.group(1))
		if suc:
			ET.SubElement(media,"url",{"localpath":lPath}).text = m.group(1) 
	
	return media
#get descriptions
def getFullText(linkURL):
	#create node
	fullText = ET.Element("fulltext")
	
	response, content = h.request(linkURL)
	s = content.decode('UTF-8')
	#regex for getting the conatainer with the descriptions	
	exp = '<div class="image-caption">(.*?)<div class=\'image-navigation\'>'
	for m in re.finditer(exp,s,re.DOTALL):
		exp = '<p>(.*?</p>.*?)</div>' 
		for htext in re.finditer(exp,m.group(1),re.DOTALL):
			fullText.text = unescape(htext.group(1))
	
	return fullText

def getShortText(item):
	shortText = ET.Element("shorttext")
	shortText.text = item.find("description").text
	return shortText
def getTitle(item):
	title = ET.Element("title")
	title.text = item.find("title").text
	return title
	
#returns TRUE if url is already in xml and FALSE if not there
def checkXML(tree,url):
	for i in tree.getiterator("item"):
		if i.attrib["link"] == unescape(url):
			return True
	return False

"""------------------------- MAIN -------------------------"""
#check if XML file exists
try:	
	root = ET.parse(xmlFile).getroot()
	mainTree = ET.ElementTree(root,xmlFile)
	print("Using existing XML file")
	#housekeeping - remove old nodes and files
	if len(root)>maxItems:	
		it = root.getiterator("item")
		delNum = len(root) - maxItems #number of elements that need to be destroyed
		killNodes = it[0:delNum] #slices out the older (top) elements
		for node in killNodes:
			for url in node.getiterator("url"): #finds associated files and deletes them
				try:
					os.remove(url.attrib["localpath"]) 
					print("DELETED FILE: " + url.attrib["localpath"])	
				except OSError as e:
					print("UNABLE TO DELETE FILE ("+url.attrib["localpath"]+"): " + str(e))
			root.remove(node)	
			print("NODE REMOVED: " + str(node))
except IOError as e:
	firstRun = True
	print("No XML file exists. Creating a new one.")
	root = ET.Element("items")
	mainTree = ET.ElementTree(root)

#open feed
h = httplib2.Http('.cache')
response, content = h.request(feedURL)

try:
	feedXML = ET.fromstring(content.decode('UTF-8'))
except XMLSyntaxError as e:
	print("WARN: Malformed XML from feed. Using recovery parser")
	sloppyParser = lxml.etree.XMLParser(recover=True)
	feedXML = lxml.etree.fromstring(content,sloppyParser)


for feedItem in feedXML.getiterator("item"):
	link = feedItem.find("link")
	#only take links from Image of the Day -- can be modified
	if link.text.find("http://earthobservatory.nasa.gov/IOTD/view.php")!=-1: #the only wart is that regex is hard coded
		if firstRun:	
			#create XML node	
			item = ET.SubElement(root,"item",{"link":link.text}) 
			#title
			item.append(getTitle(feedItem)) 
			#images
			item.append(getImages(link.text))	
			#descriptions
			item.append(getShortText(feedItem))
			item.append(getFullText(link.text))	
		elif not checkXML(mainTree,link.text):
			#create XML node	
			item = ET.SubElement(root,"item",{"link":link.text}) 
			#images
			item.append(getImages(link.text))	
			#descriptions
			item.append(getShortText(feedItem))
			item.append(getFullText(link.text))	
	
firstRun = False

#write/update file
#unsure why but it requires resetting the root
mainTree._setroot(root)
mainTree.write(xmlFile,"UTF-8")
