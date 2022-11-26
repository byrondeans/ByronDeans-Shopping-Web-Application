#Copyright 2022 Ashley Byron Deans

#Byron Deans London Publishing Limited (of 18 Cervantes Court, Northwood, Middlesex England HA6 1AL, Registered Number 12271552) hereby disclaims all copyright interest in the program "The ByronDeans Shopping Web Application" (which helps people shop) written by Ashley Byron Deans.

#Byron Deans, 19 November 2022
#Ashley Byron Deans, Director of Byron Deans London Publishing Limited 


#This file is part of the ByronDeans Shopping Web Application.

#The ByronDeans Shopping Web Application is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

#The ByronDeans Shopping Web Application program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

#You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.



import os
from flask import Flask, session, render_template, request, abort
from flask_session import Session
import psycopg2
import datetime, time
import random
import string

app = Flask(__name__)

# Configure session to use filesystem
app.config["SESSION_PERMANENT"] = True
app.config["SESSION_TYPE"] = "filesystem"
app.config['SECRET_KEY'] = '2Ma3CGdW4gl2GPOvcxS'
app.permanent_session_lifetime = datetime.timedelta(days=365)


@app.route('/')
def index():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_logged_in = 0
	username_logged_in = ""
	countries = []
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]
		query = "SELECT username FROM users WHERE id = " + str(user_logged_in)	
		cur.execute(query)
		username_logged_in = cur.fetchone()[0]
		if session.get("group_id") == None:
			session["group_id"] = 0
		group_logged_in = session["group_id"]

	if user_logged_in > 0:
		if group_logged_in > 0:
			country_string = "SELECT * FROM country WHERE group_id_added = " + str(group_logged_in) + " AND removed = FALSE"
		else:
			country_string = "SELECT * FROM country WHERE user_id_added = " + str(user_logged_in) + " AND group_id_added IS NULL" + " AND removed = FALSE"
			conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
			cur = conn.cursor()
		cur.execute(country_string)
		rows = cur.fetchall()
		countries = []
		for row in rows:
			country_array = []
			country_array.append(row[0])
			country_array.append(row[1])
			countries.append(country_array)

		session["basket"] = {}
		session["num_goods_in_basket"] = 0
		session["excluded_stores"] = []

	return render_template("index.html", countries=countries, user_logged_in=user_logged_in, username_logged_in=username_logged_in)

@app.route("/register_new_user", methods=["GET", "POST"])
def register_new_user():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	message = ""
	nosubmit = 1
	if request.method == "POST":
		nosubmit = 0
		username = request.form.get("username")
		password = request.form.get("password")
		cur.execute("SELECT * FROM users WHERE username='%s'" % username)
		users = cur.fetchall()
		if(users):
			message = "Username already exists"
		else:
			current_timestamp = time.time()
			cur.execute("INSERT INTO users (username, password, created_on) VALUES ('" + username + "', '" + password + "', " + str(current_timestamp) + ") returning id")
			user_id = cur.fetchone()[0]	
			conn.commit()
			session['user_logged_in'] = user_id
			message = "Welcome " + username

	return render_template("register_new_user.html", nosubmit=nosubmit, message=message)


@app.route("/login", methods=["GET", "POST"])
def login():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	test = 0
	already_logged_in = 0
	nosubmit = 1
	if session.get("user_logged_in") != None:
		already_logged_in = 1
		
	if request.method == "POST":	
		nosubmit = 0
		username = request.form.get("username")
		password = request.form.get("password")
		cur.execute("SELECT * FROM users WHERE username='%s'" % username)
		users = cur.fetchall()
		if(len(users) == 1):
			test = users[0][2]
			db_password = users[0][2]
			if password == db_password:
				session['user_logged_in'] = users[0][0]

	return render_template("login.html", already_logged_in=already_logged_in, test=test, nosubmit=nosubmit)

@app.route("/logout", methods=["GET", "POST"])
def logout():
	if session.get("user_logged_in") != None:
		user_id = session['user_logged_in']
		session.pop('user_logged_in', None)
	return render_template("logout.html")

@app.route("/select_region/<int:country_id>", methods=['GET'])
def select_region(country_id):	
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()

	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	if group_logged_in > 0:
		query_string = "SELECT * FROM region WHERE group_id_added =  " + str(group_logged_in) + " AND country_id = " + str(country_id) + " AND removed = FALSE"
		cur.execute(query_string)
	else:	
		query_string = "SELECT * FROM region WHERE user_id_added =  " + str(user_logged_in) + " AND country_id = " + str(country_id) + " AND removed = FALSE AND group_id_added IS NULL"	
		cur.execute(query_string)
	rows = cur.fetchall()
	regions = []
	for row in rows:
		region_array = []
		region_array.append(row[0])
		region_array.append(row[1])
		regions.append(region_array)
	return render_template("select_region.html", country_id=country_id, regions=regions, query_string=query_string)

@app.route("/select_city/<int:region_id>", methods=['GET'])
def select_city(region_id):	
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	if group_logged_in > 0:
		query_string = "SELECT * FROM city WHERE region_id = " + str(region_id) + " AND group_id_added = " + str(group_logged_in) + " AND removed = FALSE"
	else:
		query_string = "SELECT * FROM city WHERE region_id = " + str(region_id) + " AND user_id_added = " + str(user_logged_in) + " AND removed = FALSE" 
	cur.execute(query_string)
	rows = cur.fetchall()
	cities = []
	for row in rows:
		city_array = []
		city_array.append(row[0])
		city_array.append(row[1])
		cities.append(city_array)
	return render_template("select_city.html", region_id=region_id, cities=cities)


@app.route("/add_city", methods=["GET", "POST"])
def add_city():
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	test = ""
	username_logged_in = ""
	region_id = request.args.get("region_id")

	added_city = 0
	if user_logged_in > 0:
		if request.method == "POST":
			form = request.form
			city_name = form["city"]
			
			conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
			cur = conn.cursor()
			unixtime = time.time()
			if group_logged_in > 0:
				query_string = "INSERT INTO city (name, region_id, user_id_added, group_id_added, unixtime_added, removed) VALUES ('" + str(city_name) + "', " + str(region_id) + ", " + str(user_logged_in) + ", " + str(group_logged_in) + ", " + str(unixtime) + ", FALSE)"
			else:		
				query_string = "INSERT INTO city (name, region_id, user_id_added, unixtime_added, removed) VALUES ('" + str(city_name) + "', " + str(region_id) + ", " + str(user_logged_in) + ", " + str(unixtime) + ", FALSE)"
			cur.execute(query_string)
			conn.commit()
			added_city = 1

	return render_template("add_city.html", added_city=added_city, region_id=region_id)



@app.route("/remove_city", methods=["GET", "POST"])
def remove_city():
	city_id = 0

	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	group_from_db = 0
	removed_city = 0
	unixtime = time.time()
	region_id = 0
	if request.method == "GET":
		city_id = request.args.get("city_id")	
		test = 2
		query_string = "SELECT * FROM city WHERE id = " + str(city_id)
		cur.execute(query_string)
		city_data = cur.fetchone()
		region_id = city_data[2]
		if group_logged_in > 0:
			group_from_db = int(city_data[4])
			if group_from_db == group_logged_in:
				query_string = "UPDATE city SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(city_id)
				cur.execute(query_string)
				conn.commit()
				removed_city = 1
		else:
			user_from_db = int(city_data[3])
			if user_from_db == user_logged_in:
				query_string = "UPDATE city SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(city_id)
				cur.execute(query_string)
				conn.commit()
				removed_city = 1

	return render_template("remove_city.html", region_id=region_id, removed_city=removed_city, group_logged_in=group_logged_in, group_from_db=group_from_db, city_data=city_data)




@app.route("/select_district/<int:city_id>", methods=['GET'])
def select_district(city_id):		
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	if group_logged_in > 0:
		query_string = "SELECT * FROM district WHERE city_id = " + str(city_id) + " AND group_id_added = " + str(group_logged_in) + " AND removed = FALSE"
	else:
		query_string = "SELECT * FROM district WHERE city_id = " + str(city_id) + " AND user_id_added = " + str(user_logged_in) + " AND removed = FALSE" 
	cur.execute(query_string)
	
	rows = cur.fetchall()
	districts = []
	for row in rows:
		district_array = []
		district_array.append(row[0])
		district_array.append(row[1])
		districts.append(district_array)
	return render_template("select_district.html", city_id=city_id, districts=districts, user_id=user_logged_in, group_id=group_logged_in, query=query_string)

@app.route("/add_district", methods=["GET", "POST"])
def add_district():
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	test = ""
	username_logged_in = ""
	city_id = request.args.get("city_id")

	added_district = 0
	if user_logged_in > 0:
		if request.method == "POST":
			form = request.form
			district_name = form["district"]
			
			conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
			cur = conn.cursor()
			unixtime = time.time()
			if group_logged_in > 0:
				query_string = "INSERT INTO district (name, city_id, user_id_added, group_id_added, unixtime_added, removed) VALUES ('" + str(district_name) + "', " + str(city_id) + ", " + str(user_logged_in) + ", " + str(group_logged_in) + ", " + str(unixtime) + ", FALSE)"
			else:		
				query_string = "INSERT INTO district (name, city_id, user_id_added, unixtime_added, removed) VALUES ('" + str(district_name) + "', " + str(city_id) + ", " + str(user_logged_in) + ", " + str(unixtime) + ", FALSE)"
			cur.execute(query_string)
			conn.commit()
			added_district = 1

	return render_template("add_district.html", added_district=added_district, city_id=city_id)


@app.route("/select_items", methods=["GET", "POST"])
def select_items():
	unixtime = time.time()
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]
		query = "SELECT username FROM users WHERE id = " + str(user_logged_in)
		cur.execute(query)
		username_logged_in = cur.fetchone()[0]
		if session.get("group_id") == None:
			session["group_id"] = 0
		group_logged_in = session["group_id"]

	districts = []
	form = ""
	if request.method == "POST":
		form = request.form
		for dist in form:
			districts.append(dist)
		session["districts"] = districts
		first = 1
		district_string = ""
		for district in districts:
			if first == 1:
				first = 0
				district_string += district
			else:
				district_string += ", " + district

		query_string = "INSERT INTO district_choice (user_id, group_id, created_on, choice_string) VALUES (" + str(user_logged_in) + ", " + str(group_logged_in) + ", " + str(unixtime) + ", '" + district_string + "')" 
		cur.execute(query_string)
		conn.commit()
	else:
		districts = session["districts"]
	
	user_id_logged_in = session["user_logged_in"]
	if group_logged_in > 0:
		search_string = "select distinct on (product.id) * from product left join product_store on product_store.product_id = product.id left join store on store.id = product_store.store_id where product_store.removed = FALSE AND product.group_id = " + str(group_logged_in) + " AND (district_id = "
	else:
		search_string = "select distinct on (product.id) * from product left join product_store on product_store.product_id = product.id left join store on store.id = product_store.store_id where product_store.removed = FALSE AND product.user_added = " + str(user_id_logged_in) + " AND product.group_id IS NULL AND (district_id = "
	first = 1
	for district in districts:
		if first == 1:
			search_string += district
			first = 0
		else:
			search_string += " OR district_id = " + district 	
	search_string += ")"
	cur.execute(search_string)
	rows = cur.fetchall()

	districts = session["districts"]
	session_basket = session["basket"]
	num_goods_in_basket = session["num_goods_in_basket"]

	district_string = ""
	first = 1
	for district in districts:
		query_string = "SELECT name FROM district WHERE id = " + str(district)
		cur.execute(query_string)
		dist_name = cur.fetchone()
		if first == 1:
			district_string += dist_name[0] 
			first = 0
		else:
			district_string += ", " + dist_name[0]
	return render_template("select_item.html", rows=rows, districts=districts, session_basket=session_basket, num_goods_in_basket=num_goods_in_basket, user_logged_in=user_logged_in, username_logged_in=username_logged_in, search_string=search_string, district_string=district_string)

 
@app.route("/add_item_to_basket", methods=["GET", "POST"])
def add_item_to_basket():	
	product_id = request.args.get("product_id")
	districts = session["districts"]
	first = 1
	basket = []
	store_dict = []
	test = "start "
	session_basket = []
	session_old_basket = []
	error = 0
	test2 = ""
	products = []
	num_districts = len(districts)
	if session.get("excluded_stores") is None:
		excluded_stores = []
	else:	
		excluded_stores = session["excluded_stores"]	
	search_string = "select * from product_store left join store on store.id = product_store.store_id left join price on price.product_store_id = product_store.id left join product on product.id = product_store.product_id where "
	if num_districts > 1:
		search_string += "(store.district_id = "
	else:
		search_string += "store.district_id = "
	multi = 0
	for district in districts:
		if first == 1:
			search_string += district
			first = 0
		else:
			search_string += " OR store.district_id = " + district
			multi = 1
	if multi:
		search_string += ")"
	search_string += " AND product_id = " + product_id

	if len(excluded_stores):	
		for store in excluded_stores:
			search_string += " AND store.id != " + str(store)
	search_string += " AND product_store.removed = FALSE AND price.unixtime_added = (SELECT MAX (price.unixtime_added) FROM price WHERE product_store_id = product_store.id) ORDER BY price.price ASC LIMIT 1"
	
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	cur.execute(search_string)
	row = cur.fetchone()
	if row is not None:
		session_old_basket = session["basket"] 
		#session["basket"] = {}
		session_basket = session["basket"]
		test = "no"
		store_dict = {}	
		if session.get("basket") is None:
			session["basket"] = {}
			session["num_goods_in_basket"] = 0
			basket = session["basket"]
		else:
			basket = session["basket"]
			if basket == {}:
				session["num_goods_in_basket"] = 0
		#session["basket"] = {1: "test"}	
		store_id = str(row[2])
		store_name = row[10]
		product_id = str(row[1])
		#basket = {2: "test2"}
		test2 = "unset"
		products = "unset"
		if store_id in basket:
			test = "the store is in, now potentially adding a product if it isn't already in"
			store_dict = basket[store_id]
			if product_id in store_dict:
				test2 = "the product id is already in, skipping"
				store_dict[product_id] = "set again"
			else:
				test2 = "the product id is not in already, adding"
				store_dict[product_id] = "set first"		
				product_name = str(row[25])
				product_store_id = int(row[21])
				price = row[18]
				product_array = [product_id, product_store_id, product_name, price]
				products = store_dict["products"]
				products.append(product_array)
				store_dict["products"] = products		
				basket[store_id] = store_dict
				num_goods = int(session["num_goods_in_basket"])
				num_goods += 1
				session["num_goods_in_basket"] = num_goods
				session["basket"] = basket

		else:
			test = "adding store and product to basket for first time"
			store_dict = {'name': store_name}	
			store_dict[product_id] = 1 #used to prevent duplicate entries of same product
			product_name = str(row[25])
			product_store_id = str(row[21])
			price = row[18]
			product_array = [product_id, product_store_id, product_name, price]
			products = [product_array]
			store_dict["products"] = products	
			basket[store_id] = store_dict
			num_goods = int(session["num_goods_in_basket"])
			num_goods += 1
			session["num_goods_in_basket"] = num_goods
			session["basket"] = basket
	else:
		error = 1
 
	return render_template("add_item_to_basket.html", product_id=product_id, row=row, search_string=search_string, basket=basket, store_dict=store_dict, test=test, session_basket=session_basket, session_old_basket=session_old_basket, test2=test2, products=products, error=error)


@app.route("/display_stores_prices", methods=["GET", "POST"])
def display_stores_prices():
	basket = session["basket"]
	final_display_dict = {}
	test = "hello, world!"
	if session.get("excluded_stores") is None:
		excluded_stores = []
	else:	
		excluded_stores = session["excluded_stores"]	
	order_total = 0
	for store_id in basket:
		test += " " + store_id + ", "
		store_dict = basket[store_id] 
		store_name = store_dict["name"]
		product_array = store_dict["products"]
		array_for_store = []
		for product in product_array:
			price = product[3]
			order_total += float(price)
			product_name = product[2]
			product_id = product[0]
			product_array = [price, product_name, product_id, store_id]
			array_for_store.append(product_array)
		final_display_dict[store_id] = [store_name, array_for_store]

	excluded_store_display = []
	if len(excluded_stores):
		excluded_store_display = []
		conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
		cur = conn.cursor()
		for excluded_store in excluded_stores:
			search_string = "select * from store where id = " + excluded_store
			cur.execute(search_string)
			row=cur.fetchone()
			store_name = row[1]
			excluded_store_arr = [excluded_store, store_name]
			excluded_store_display.append(excluded_store_arr)

	

	return render_template("stores_prices.html", final_display_dict=final_display_dict, test=test, order_total=order_total, basket=basket, excluded_stores=excluded_stores, excluded_store_display=excluded_store_display)


@app.route("/new_item", methods=["GET", "POST"])
def new_item():
	user_id = session['user_logged_in']
	group_id = session["group_id"] 
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	form = "not posting"
	rows = "posting"
	lastrow = 0
	cont = 0
	what_was_inserted = []
	store_id = 0
	product_id_from_get = 0
	store_id_from_get = 0
	if request.args.get("product_id"):
		product_id_from_get = int(request.args.get("product_id"))
		store_id_from_get = int(request.args.get("store_id"))
	districts = session["districts"]
	search_string = "SELECT * FROM store WHERE district_id = "
	first = 1
	for district in districts:
		if first == 1:
			search_string += district
			first = 0
		else:
			search_string += " OR district_id = " + district
	if group_id == 0:
		search_string += " AND user_added = " + str(user_id)
	else:
		search_string += " AND group_id = " + str(group_id)
	search_string += " AND removed = FALSE"
	list_stores_search_string = search_string
	cur.execute(search_string)
	stores=cur.fetchall()
	if group_id == 0:
		search_string = "SELECT distinct on (product.id) * FROM product left join product_store on product_store.product_id = product.id left join store on store.id = product_store.store_id WHERE product.user_added = 1 AND product.group_id IS NULL AND product.removed = FALSE AND (store.district_id = "
		first = 1
		for district in districts:
			if first == 1:
				search_string += district
				first = 0
			else:
				search_string += " OR store.district_id = " + district
		search_string += ")"
	else:	
		search_string = "SELECT distinct on (product.id) * FROM product left join product_store on product_store.product_id = product.id left join store on store.id = product_store.store_id WHERE product.group_id = " + str(group_id) + " AND product.removed = FALSE AND store.district_id = "	
		first = 1
		for district in districts:
			if first == 1:
				search_string += district
				first = 0
			else:
				search_string += " OR store.district_id = " + district
	cur.execute(search_string)
	products=cur.fetchall()
	error = ""
	if request.method == "POST":
		form = request.form
		store_id = form["stores"]
		product_id = form["products"]
		if product_id == "0":#the dropdown id for "add new product"
			item_name = form["item_name"]
		price = form["price"]
		unixtime_added = int(time.time())
		if product_id == "0":
			if group_id == 0:
				insert_string = "INSERT INTO product (name, user_added, unixtime_added, removed) VALUES ('" + item_name + "', " + str(user_id) + ", " + str(unixtime_added) + ", FALSE) returning id"
			else:	
				insert_string = "INSERT INTO product (name, user_added, group_id, unixtime_added, removed) VALUES ('" + item_name + "', " + str(user_id) + ", " + str(group_id) + ", " + str(unixtime_added) + ", FALSE) returning id"
			cur.execute(insert_string)
			conn.commit()
			lastrow = cur.fetchone()[0]
			cont = 1
			what_was_inserted = [item_name, price]
			if group_id == 0:
				insert_string = "INSERT INTO product_store (product_id, store_id, user_added, time_added, removed) VALUES (" + str(lastrow) + ", " + str(store_id) + ", " + str(user_id) + ", " + str(unixtime_added) + ", FALSE) returning id"
			else:	
				insert_string = "INSERT INTO product_store (product_id, store_id, user_added, group_id, time_added, removed) VALUES (" + str(lastrow) + ", " + str(store_id) + ", " + str(user_id) + ", " + str(group_id) + ", " + str(unixtime_added) + ", FALSE) returning id"
			cur.execute(insert_string)
			lastrow = cur.fetchone()[0]
			if group_id == 0:
				insert_string = "INSERT INTO price (user_id, unixtime_added, product_store_id, price) VALUES (" + str(user_id) + ", " + str(unixtime_added) + ", " + str(lastrow) + ", " + price + ")"	
			else:	
				insert_string = "INSERT INTO price (user_id, group_id, unixtime_added, product_store_id, price) VALUES (" + str(user_id) + ", " + str(group_id) + ", " + str(unixtime_added) + ", " + str(lastrow) + ", " + price + ")"	
			cur.execute(insert_string)
			conn.commit()
		elif product_id == "-1":
			error = "Must select a product"
		else:
			#error = "Must add code for updating/adding new store for product"
			search_string = "select * from product_store where product_id = " + product_id + " and store_id = " + str(store_id) + " and removed = FALSE";
			cur.execute(search_string)
			row = cur.fetchone()
			if row:
#				error = "it found the product/store combo"		
				unixtime = str(int(time.time()))
				product_store_id = str(row[0])
				if group_id == 0:
					insert_string = "insert into price (price, user_id, unixtime_added, product_store_id) values (" + price + ", " + str(user_id) + ", " + unixtime + ", " + product_store_id + ")"	
				else:	
					insert_string = "insert into price (price, user_id, group_id, unixtime_added, product_store_id) values (" + price + ", " + str(user_id) + ", " + str(group_id) + ", " + unixtime + ", " + product_store_id + ")"	
				cur.execute(insert_string)
				conn.commit()
			else:
				if group_id == 0:
					insert_string = "insert into product_store (product_id, store_id, user_added, removed) values (" + product_id + ", " + store_id + ", " + str(user_id) + ", FALSE) returning id"	
				else:		
					insert_string = "insert into product_store (product_id, store_id, user_added, group_id, removed) values (" + product_id + ", " + store_id + ", " + str(user_id) + ", " + str(group_id) + ", FALSE) returning id"	

				cur.execute(insert_string)
				conn.commit()
				lastrow = cur.fetchone()[0]
				product_store_id = lastrow
				if group_id == 0:
					insert_string = "insert into price (price, user_id, unixtime_added, product_store_id) values (" + price + ", " + str(user_id) + ", " + str(unixtime_added) + ", " + str(product_store_id) + ")"	
				else:	
					insert_string = "insert into price (price, user_id, group_id, unixtime_added, product_store_id) values (" + price + ", " + str(user_id) + ", " + str(group_id) + ", " + str(unixtime_added) + ", " + str(product_store_id) + ")"	
				cur.execute(insert_string)
				conn.commit()

			#next step is to add a new product_store and a new price for it
	return render_template("new_item.html", store_id=store_id, form=form, stores=stores, cont=cont, what_was_inserted=what_was_inserted, lastrow=lastrow, products=products, error=error, product_id_from_get=product_id_from_get, store_id_from_get=store_id_from_get, list_stores_search_string=list_stores_search_string)


@app.route("/exclude_store", methods=["GET", "POST"])
def exclude_store():
	proceed = 0
	timestamp = time.time()
	test = "no" + str(timestamp) + " "
	basket = session["basket"]
	exclude_store_id = request.args.get("store_id")
	pulled_no_record = 0
	districts = session["districts"]
	raw_sql = ""
	if session.get("excluded_stores") is None:
		excluded_stores = []
	else:
		excluded_stores = session["excluded_stores"]
		if request.args.get("remove_exclude") == "1":
			test += " saw the remove exclude"
			store_to_remove = request.args.get("unexclude_store_id")
			test += " excluded stores was: " + str(excluded_stores)
			#excluded_stores_length_before = len(excluded_stores)
			excluded_stores.remove(store_to_remove)
			test += " excluded stores now is: " + str(excluded_stores)
			if excluded_stores is not None:
				session["excluded_stores"] = excluded_stores
			else:	
				session["excluded_stores"] = []
				excluded_stores = []
			proceed = 1
		

	final_product_id_array = []
	new_basket = {}
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()

	if exclude_store_id is not None:	
		if exclude_store_id not in excluded_stores:
			proceed = 1	
			excluded_stores.append(exclude_store_id)
	if proceed:
		test += "yes"
		session["num_goods_in_basket"] = 0
		session["excluded_stores"] = excluded_stores
		#rework the session contents to exclude the store and recalculate the prices
		for product in basket:
			product_array = basket[product]['products']
			for product_id in product_array:
				final_product_id_array.append(product_id[0])
				
		num_districts = len(districts)
		len_of_final_product_id_array = len(final_product_id_array)
		for product_id in final_product_id_array:
			
			first = 1
			search_string = "select * from product_store left join store on store.id = product_store.store_id left join price on price.product_store_id = product_store.id left join product on product.id = product_store.product_id where ("
			if num_districts > 1:
				search_string += "store.district_id = "
			else:
				search_string += "store.district_id = "
			for district in districts:
				if first == 1:
					search_string += district
					first = 0
				else:
					search_string += " OR store.district_id = " + district
			search_string += ")"
			search_string += " AND product_id = " + str(product_id)
			search_string += " AND product_store.removed = FALSE"
		
			if len(excluded_stores):	
				for store in excluded_stores:
					search_string += " AND store.id != " + str(store)
			
			search_string += " AND price.unixtime_added = (SELECT MAX (price.unixtime_added) FROM price WHERE product_store_id = product_store.id) ORDER BY price.price ASC LIMIT 1"
	
			cur.execute(search_string)
			row = cur.fetchone()
			raw_sql += str(row)
			session_old_basket = session["basket"] 
			if(row is not None):
				store = row[2]
				store_name = row[10]
				store_id = str(row[2])
				if store_id in new_basket:
					test += "the store is in, now potentially adding a product if it isn't already in - store_id is: " + store_id
					store_dict = new_basket[store_id]
					if product_id in store_dict:
						test2 = "the product id is already in, skipping"
						store_dict[product_id] = "set again"
					else:
						test2 = "the product id is not in already, adding"
						store_dict[product_id] = "set first"		
						product_name = str(row[25])
						product_store_id = int(row[21])
						price = row[18]
						product_array = [product_id, product_store_id, product_name, price]
						products = store_dict["products"]
						products.append(product_array)
						store_dict["products"] = products		
						new_basket[store_id] = store_dict
						num_goods = int(session["num_goods_in_basket"])
						num_goods += 1
						session["num_goods_in_basket"] = num_goods
						session["basket"] = new_basket

				else:
					test += "adding store and product to basket for first time - store_id is: " + store_id + " and row is " + str(row)
					store_dict = {'name': store_name}	
					store_dict[product_id] = 1 #used to prevent duplicate entries of same product
					product_name = str(row[25])
					product_store_id = str(row[21])
					price = row[18]
					product_array = [product_id, product_store_id, product_name, price]
					products = [product_array]
					store_dict["products"] = products	
					new_basket[store_id] = store_dict
					num_goods = int(session["num_goods_in_basket"])
					num_goods += 1
					session["num_goods_in_basket"] = num_goods
					session["basket"] = new_basket
	

			else:
				pulled_no_record += 1
		if len_of_final_product_id_array == pulled_no_record:
			session["basket"] = {}
			session["num_goods_in_basket"]
			test += "Emptied the basket due to no products showing up in search" 

	#excluded_stores = session["excluded_stores"]
	return render_template("exclude_store.html", test=test, basket=basket, final_product_id_array=final_product_id_array, new_basket=new_basket, excluded_stores=excluded_stores, raw_sql=raw_sql)	


@app.route("/remove_product_from_basket", methods=["GET", "POST"])
def remove_product_from_basket():
	product_id = request.args.get("product_id")
	store_id = request.args.get("store_id")
	session_basket = session["basket"]
	basket = session["basket"]
	relevant_store = basket[store_id]
	#relevant_store[product_id] = "unset"
	if product_id in relevant_store: 
		del relevant_store[product_id]
		products = relevant_store["products"]
		new_products = []
		session["num_goods_in_basket"] -= 1
		for i in products:
			if i[0] != product_id:
				new_products.append(i)
		if len(products) == 1:
			del basket[store_id]
		else:
			relevant_store["products"] = new_products
			basket[store_id] = relevant_store
	
	return render_template("remove_from_basket.html", product_id=product_id, store_id=store_id, basket=basket, session_basket=session_basket)


@app.route("/remove_product_from_store", methods=["GET", "POST"])
def remove_product_from_store():	
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	product_id = request.args.get("product_id")
	store_id = request.args.get("store_id")
	unixtime_removed = int(time.time())
	user_id = session["user_logged_in"]
	remove_string = "update product_store set removed = TRUE, user_removed = " + str(user_id) + ", time_removed = " + str(unixtime_removed) + " where product_id = " + product_id + " and store_id = " + store_id
	cur.execute(remove_string)
	conn.commit()
	search_string = "select * from product_store where product_id = " + str(product_id) + " AND removed = FALSE"
	cur.execute(search_string)
	products = cur.fetchone()
	test = 0
	if products is None:
		remove_string = "update product set removed = TRUE where id = " + product_id
		cur.execute(remove_string)
		conn.commit()
		test = 1
	return render_template("remove_from_store.html", test=test)

@app.route("/product_details", methods=["GET", "POST"])
def product_details():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	product_id = request.args.get("product_id")
	search_string = "select * from product_store where product_id = " + product_id	
	cur.execute(search_string)
	product_stores = cur.fetchall()

	if len(product_stores) == 1:
		product_store_id = str(product_stores[0][0])
		search_string = "select * from product_store left join store on store.id = product_store.store_id left join price on price.product_store_id = product_store.id left join product on product.id = product_store.product_id where product_id = " + product_id + " AND price.unixtime_added = (SELECT MAX (price.unixtime_added) FROM price WHERE " + product_store_id + " = price.product_store_id)" 
	else:
		search_string = "select * from product_store left join store on store.id = product_store.store_id left join price on price.product_store_id = product_store.id left join product on product.id = product_store.product_id where product_id = " + product_id + " AND product_store.removed = FALSE AND price.unixtime_added = (SELECT MAX (price.unixtime_added) FROM price WHERE "
		first_iteration = 1
		for i in product_stores:
			product_id = str(i[0])
			if first_iteration:
				search_string += product_id + " = price.product_store_id)"
				first_iteration = 0
			else:
				search_string += " OR price.unixtime_added = (SELECT MAX (price.unixtime_added) FROM price WHERE " + product_id + " = price.product_store_id) AND product_store.removed = FALSE"	
	test = search_string		
	cur.execute(search_string)
	product_store_price_array = cur.fetchall()

	return render_template("product_details.html", product_stores=product_stores, test=test, product_store_price_array=product_store_price_array)


@app.route("/manage_store", methods=["GET", "POST"])
def manage_store():	
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_id = session["user_logged_in"]
	group_id = session["group_id"]
	districts_string = ""
	session_districts = session["districts"]
	first = 1
	for district in session_districts:
		if first == 1:
			districts_string += str(district)
			first = 0
		else:
			districts_string += " OR id = " + str(district)
	districts_string += ")"
	
	if group_id > 0:
		search_string = "SELECT * FROM district WHERE group_id_added = " + str(group_id) + " AND removed = FALSE AND (id = " + districts_string
	else:	
		search_string = "SELECT * FROM district WHERE user_id_added = " + str(user_id) + " AND group_id_added IS NULL AND removed = FALSE AND (id = " + districts_string
	cur.execute(search_string)
	districts = cur.fetchall()
	test = 0
	form = "unset"
	store_name = "unset"
	if request.method == "POST":
		test = 2
		form = request.form
		store_name = form['store_name']
		store_district = int(form['districts'])
		if group_id == 0:	
			query_string = "INSERT INTO store (name, district_id, user_added, removed) VALUES ('" + store_name + "', " + str(store_district) + ", " + str(user_id) + ", FALSE)"	
		else:
			query_string = "INSERT INTO store (name, district_id, user_added, group_id, removed) VALUES ('" + store_name + "', " + str(store_district) + ", " + str(user_id) + ", " + str(group_id) + ", FALSE)"
		cur.execute(query_string)
		conn.commit()

	if request.args.get("store_id"):
		test = 1
		store_id = request.args.get("store_id")
		remove_string = "update store set removed = TRUE AND user_removed = " + str(user_id) + " where id = " + store_id
		session["basket"] = {} #erase the basket if removing a store to avoid any bugs connected to that
		session["num_goods_in_basket"] = 0
		cur.execute(remove_string)
		conn.commit()


	districts_string = ""
	first = 1
	for district in session_districts:
		if first == 1:
			districts_string += str(district)
			first = 0
		else:
			districts_string += " OR district_id = " + str(district)
	districts_string += ")"
	if group_id == 0:	
		search_string = "select * from store where user_added = " + str(user_id) + " AND group_id IS NULL AND removed = FALSE AND (district_id = " + districts_string
	else:	
		search_string = "select * from store where group_id = " + str(group_id) + " removed = FALSE AND (district_id = " + districts_string
	cur.execute(search_string)
	stores = cur.fetchall()
	return render_template("manage_store.html", stores=stores, test=test, districts=districts, form=form, store_name=store_name, session_districts=session_districts)


@app.route("/groups", methods=["GET", "POST"])
def groups():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_id = session["user_logged_in"]
	selected_group_string = ""
	query_string = ""
	group_array = []
	old_groups_districts_string = ""
	group_id_from_db = 0
	if request.method == "POST":#there are some security-connected things going on here, where I don't care if a user can see his own information, but otherwise, I do a check to make sure he has permission to see a group's information
		form = request.form
		selected_group = form['group']
		created_on = time.time()
		old_group_id = session["group_id"]
		if int(selected_group) > 1:
			search_string = "select * from user_group where id = " + str(selected_group) + " and removed = FALSE"
			cur.execute(search_string)
			group = cur.fetchone()
			user_id_from_db = group[1]
			group_id_from_db = group[2]
			if int(user_id) == int(user_id_from_db):
				query_string = "insert into user_group_toggle (user_id, user_group_id, created_on) values (" + str(user_id) + ", " + str(int(selected_group)) + ", " + str(created_on) + ")"
				cur.execute(query_string)
				conn.commit()
				session["group_id"] = int(group_id_from_db)
				
				session["basket"] = {}
				session["num_goods_in_basket"] = 0
				session["excluded_stores"] = []
		else:
			query_string = "insert into user_group_toggle (user_id, user_group_id, created_on) values (" + str(user_id) + ", 0, " + str(created_on) + ")"
			cur.execute(query_string)
			conn.commit()
			session["group_id"] = int(selected_group)
			session["basket"] = {}
			session["num_goods_in_basket"] = 0
			session["excluded_stores"] = []
		query_string = "SELECT * FROM district_choice WHERE user_id = " + str(user_id) + " AND group_id = " + str(group_id_from_db) + " ORDER BY created_on DESC LIMIT 1" 
		cur.execute(query_string)
		selected_group_string = cur.fetchone()
		if selected_group_string != None:
			group_string = selected_group_string[4]
		else:
			group_string = ""
		group_array = group_string.split(", ")
		old_groups_districts = session["districts"]
		session["districts"] = group_array
		first = 1
		old_groups_districts_string = ""
		for i in old_groups_districts:
			if first:
				old_groups_districts_string += str(i)
				first = 0
			else:
				old_groups_districts_string += ", " + str(i)
		insert_string = "INSERT INTO district_choice (user_id, group_id, created_on, choice_string) VALUES (" + str(user_id) + ", " + str(old_group_id) + ", " + str(created_on) + ", '" + str(old_groups_districts_string) + "'"
		cur.execute(query_string)
		conn.commit()	

	search_string = "select * from shopping_group left join user_group on user_group.shopping_group_id = shopping_group.id left join user_admin on user_admin.shopping_group_id = shopping_group.id where user_group.user_id = " + str(user_id) + " and user_group.removed = FALSE and shopping_group.removed = FALSE" 
	cur.execute(search_string)
	groups = cur.fetchall()
	test = "Hello, world!"

	search_string = "select * from user_group_toggle where user_id = " + str(user_id) + " ORDER BY created_on DESC LIMIT 1"
	cur.execute(search_string)
	selected_radio = cur.fetchone()
	if selected_radio != None:
		selected_radio_user_group_id = selected_radio[3]
	else:
		selected_radio_user_group_id = 0

	session_districts = session["districts"]	
	return render_template("groups.html", test=test, groups=groups, selected_radio_user_group_id=selected_radio_user_group_id, user_id=user_id, selected_group_string=selected_group_string, query_string=query_string, group_array=group_array, old_groups_districts_string=old_groups_districts_string, session_districts=session_districts)

@app.route("/create_group", methods=["GET", "POST"])
def create_group():
	test = "Hello, world!"
	user_id = session["user_logged_in"]
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	unixtime = time.time()
	if request.method == "POST":
		form = request.form
		name = form["group_name"]
		insert_string = "INSERT INTO shopping_group (user_id_created, unixtime_created, name, removed) VALUES (" + str(user_id) + ", " + str(unixtime) + ", '" + str(name) + "', FALSE) returning id"
		cur.execute(insert_string)
		group_id = cur.fetchone()[0]
		conn.commit()
		insert_string = "INSERT INTO user_admin (user_id, shopping_group_id, unixtime_added, removed) VALUES (" + str(user_id) + ", " + str(group_id) + ", " + str(unixtime) + ", FALSE)"	
		cur.execute(insert_string)
		conn.commit()
		insert_string = "INSERT INTO user_group (user_id, shopping_group_id, unixtime_added, removed) VALUES (" + str(user_id) + ", " + str(group_id) + ", " + str(unixtime) + ", FALSE)"	
		cur.execute(insert_string)
		conn.commit()

		test = "Your group has been successfully created and group_id is " + str(group_id)	
	return render_template("create_group.html", test=test)


@app.route("/leave_group", methods=["GET", "POST"])
def leave_group():
	user_group_id = request.args.get("user_group_id") 
	user_id = session["user_logged_in"]
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	unixtime = time.time()
	search_string = "select * from user_group left join shopping_group on shopping_group.id = user_group.shopping_group_id where user_group.id = " + str(user_group_id)
	cur.execute(search_string)
	group = cur.fetchone()
	user_id_in_db = group[1]
	group_name_in_db = group[14]
	message = "Before the if clause"
	if int(user_id) == int(user_id_in_db):
		
		remove_string = "update user_group set removed = TRUE where id = " + str(user_group_id)
		cur.execute(remove_string)
		conn.commit()
		 
		message = "Removing group number no need with user_id from db " + str(user_id_in_db) + " and group name " + str(group_name_in_db)
	else:
		message = "Security problem or already removed the group"
	return render_template("leave_group.html", message=message)

@app.route("/group_admin", methods=["GET", "POST"])
def group_admin():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_id = session["user_logged_in"]
	search_string = "select * from shopping_group left join user_group on user_group.shopping_group_id = shopping_group.id left join user_admin on user_admin.shopping_group_id = shopping_group.id where user_group.user_id = " + str(user_id) + " and user_group.removed = FALSE and shopping_group.removed = FALSE and user_admin.user_id = 1 and user_admin.removed = FALSE" 
	cur.execute(search_string)	
	groups = cur.fetchall()

	return render_template("group_admin.html", groups=groups)

@app.route("/admin_view_group", methods=["GET", "POST"])
def admin_view_group():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_id = session["user_logged_in"]
	user_group_id = request.args.get("group_id")
	search_string = "select * from user_group left join users on users.id = user_group.user_id where shopping_group_id = " + str(user_group_id) + " and removed = FALSE"
	cur.execute(search_string)	
	users = cur.fetchall()
	return render_template("admin_view_group.html", users=users, group_id=user_group_id)

@app.route("/admin_remove_user", methods=["GET", "POST"])
def admin_remove_user():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	user_logged_in_id = session["user_logged_in"]
	group_id = request.args.get("group_id")
	user_id = request.args.get("user_id")
	search_string = "select * from user_admin where user_id = " + str(user_logged_in_id) + " and shopping_group_id = " + str(group_id)
	cur.execute(search_string)
	admin = cur.fetchone()
	error = 0
	
	if admin[1] == user_logged_in_id:
		query_string = "update user_group set removed = TRUE where shopping_group_id = " + str(group_id) + " and user_id = " + str(user_id)	
		cur.execute(query_string)	
		conn.commit()
	else:
		error = 1
	return render_template("admin_remove_user.html", group_id_to_return_to=group_id, error=error, admin=admin)

@app.route("/create_invite_link", methods=["GET", "POST"])
def create_invite_link():
	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	group_id = request.args.get("group_id")
	user_logged_in_id = session["user_logged_in"]
	timestamp = time.time()
	char_set = string.ascii_uppercase + string.digits
	link_code =  ''.join(random.sample(char_set*20, 20))
	query_string = "insert into invite_links (link_code, group_id, user_generated, created_on, used_by) VALUES ('" + link_code + "', " + str(group_id) + ", " + str(user_logged_in_id) + ", " + str(timestamp) + ", 0)"
	cur.execute(query_string)
	conn.commit()	 
	return render_template("admin_create_invite_link.html", group_id=group_id, link_code=link_code)

@app.route("/redeem_invite_link", methods=["GET", "POST"])
def redeem_invite_link():
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]
	group_name = ""
	error = 0
	used_by = -1
	if user_logged_in:
		conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
		cur = conn.cursor()
		invite_link = request.args.get("f")
		query_string = "select * from invite_links left join shopping_group on shopping_group.id = invite_links.group_id where link_code = '" + str(invite_link) + "'"
		cur.execute(query_string)
		invite_from_db = cur.fetchone()
		timestamp = time.time()
		if invite_from_db[1] == invite_link:
			used_by = invite_from_db[6]
			if used_by == 0:
				query_string = "update invite_links set (used_on, used_by) = (" + str(timestamp) + ", " + str(user_logged_in) + ")"
				cur.execute(query_string)
				conn.commit()
				shopping_group_id = invite_from_db[2]
				query_string = "insert into user_group (user_id, shopping_group_id, unixtime_added, removed) VALUES (" + str(user_logged_in) + ", " + str(shopping_group_id) + ", " + str(timestamp) + ", FALSE)"
				cur.execute(query_string)
				conn.commit() 
				group_name = invite_from_db[13]
			else:
				error = 3 #used the invite link already
		else:
			error = 1#something's wrong with the invite link; this is a pointless check; consider revising
	else:
		error = 2#user is not logged in
	return render_template("redeem_invite_link.html", error=error, group_name=group_name, used_by=used_by)


@app.route("/add_country", methods=["GET", "POST"])
def add_country():
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	username_logged_in = ""

	added_country = 0
	if user_logged_in > 0:
		if request.method == "POST":
			form = request.form
			country_name = form["country"]
			
			conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
			cur = conn.cursor()
			unixtime = time.time()
			if group_logged_in > 0:
				query_string = "INSERT INTO country (name, user_id_added, group_id_added, unixtime_added, removed) VALUES ('" + str(country_name) + "', " + str(user_logged_in) + ", " + str(group_logged_in) + ", " + str(unixtime) + ", FALSE)"
			else:		
				query_string = "INSERT INTO country (name, user_id_added, unixtime_added, removed) VALUES ('" + str(country_name) + "', " + str(user_logged_in) + ", " + str(unixtime) + ", FALSE)"
			cur.execute(query_string)
			conn.commit()
			added_country = 1

	return render_template("add_country.html", user_logged_in=user_logged_in, username_logged_in=username_logged_in, added_country=added_country)

@app.route("/remove_country", methods=["GET", "POST"])
def remove_country():
	country_id = 0

	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	group_from_db = 0
	removed_country = 0
	unixtime = time.time()
	if request.method == "GET":
		country_id = request.args.get("country_id")	
		query_string = "SELECT * FROM country WHERE id = " + str(country_id)
		cur.execute(query_string)
		country_data = cur.fetchone()
		if group_logged_in > 0:
			group_from_db = int(country_data[3])
			if group_from_db == group_logged_in:
				query_string = "UPDATE country SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(country_id)
				cur.execute(query_string)
				conn.commit()
				removed_country = 1
		else:
			user_from_db = int(country_data[2])
			if user_from_db == user_logged_in:
				query_string = "UPDATE country SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(country_id)
				cur.execute(query_string)
				conn.commit()
				removed_country = 1

	return render_template("remove_country.html", country_id=country_id, removed_country=removed_country, group_logged_in=group_logged_in, group_from_db=group_from_db, country_data=country_data)

@app.route("/add_region", methods=["GET", "POST"])
def add_region():
	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	username_logged_in = ""
	country_id = request.args.get("country_id")

	added_region = 0
	if user_logged_in > 0:
		if request.method == "POST":
			form = request.form
			region_name = form["region"]
			
			conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
			cur = conn.cursor()
			unixtime = time.time()
			if group_logged_in > 0:
				query_string = "INSERT INTO region (name, country_id, user_id_added, group_id_added, unixtime_added, removed) VALUES ('" + str(region_name) + "', " + str(country_id) + ", " + str(user_logged_in) + ", " + str(group_logged_in) + ", " + str(unixtime) + ", FALSE)"
			else:		
				query_string = "INSERT INTO region (name, country_id, user_id_added, unixtime_added, removed) VALUES ('" + str(region_name) + "', " + str(country_id) + ", " + str(user_logged_in) + ", " + str(unixtime) + ", FALSE)"
			cur.execute(query_string)
			conn.commit()
			added_region = 1

	return render_template("add_region.html", added_region=added_region, country_id=country_id)

@app.route("/remove_region", methods=["GET", "POST"])
def remove_region():
	region_id = 0

	if session.get("user_logged_in") == None:
		session["user_logged_in"] = 0
	elif (session["user_logged_in"] > 0):
		user_logged_in = session["user_logged_in"]

	if session.get("group_id") == None:
		session["group_id"] = 0
	group_logged_in = session["group_id"]

	conn = psycopg2.connect("dbname=byronslist user=abyrondeans")
	cur = conn.cursor()
	group_from_db = 0
	removed_region = 0
	unixtime = time.time()
	country_id = 0
	if request.method == "GET":
		region_id = request.args.get("region_id")	
		query_string = "SELECT * FROM region WHERE id = " + str(region_id)
		cur.execute(query_string)
		region_data = cur.fetchone()
		country_id = region_data[2]
		if group_logged_in > 0:
			group_from_db = int(region_data[4])
			if group_from_db == group_logged_in:
				query_string = "UPDATE region SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(region_id)
				cur.execute(query_string)
				conn.commit()
				removed_region = 1
		else:
			user_from_db = int(region_data[3])
			if user_from_db == user_logged_in:
				query_string = "UPDATE region SET removed = TRUE, unixtime_removed = " + str(unixtime) + ", user_id_removed = " + str(user_logged_in) + " WHERE id = " + str(region_id)
				cur.execute(query_string)
				conn.commit()
				removed_region = 1

	return render_template("remove_region.html", country_id=country_id, removed_region=removed_region, group_logged_in=group_logged_in, group_from_db=group_from_db, region_data=region_data)


app.run(host='0.0.0.0', port=81)
