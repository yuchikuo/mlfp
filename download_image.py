import urllib
import os

def download_img(url, filename):
	image = urllib.URLopener()
	image.retrieve(url, filename)
#url = 'http://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.720032,-73.988354&sensor=false'
#filename='test.jpg'
#download_img(url, filename)

def download_streetview(filename, lag, lng, height=640, width=640):
	url = 'http://maps.googleapis.com/maps/api/streetview?size=' + str(height)\
		+ 'x' + str(width) + '&location=' + str(lag) + ',' + str(lng) + '&sensor=false'
	download_img(url, filename)
download_streetview('test2.jpg', 40.72, -73.99)