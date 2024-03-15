SELECT * FROM products
SELECT * FROM suppliers
SELECT * FROM orders
SELECT * FROM order_details
SELECT * FROM employees
SELECT * FROM suppliers
SELECT * FROM shippers
SELECT * FROM territories

--+26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id, p.product_name, s.company_name, s.contact_name, s.phone FROM products p 
	INNER JOIN suppliers s ON p.supplier_id = s.supplier_id WHERE p.units_in_stock = 0;
--+27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, e.first_name, e.last_name FROM orders o 
	INNER JOIN employees e ON o.employee_id = e.employee_id WHERE o.order_date BETWEEN '1998-03-02' AND '1998-03-31';
--+28. 1997 yılı şubat ayında kaç siparişim var?
SELECT count(*) AS "February Orders" FROM orders o WHERE order_date BETWEEN '1997-02-03' AND '1997-02-28';
--+29. London şehrinden 1998 yılında kaç siparişim var?
SELECT count(*) AS "Orders from London" FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id 
	WHERE c.city = 'London' AND o.order_date BETWEEN '1998-01-01' AND '1998-12-31';
--+30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT DISTINCT c.contact_name, c.phone FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id 
	WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31';
--+31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT count(*) AS "Orders that their freight is 40 and more than 40" FROM orders WHERE freight >= 40;
--+32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT DISTINCT o.ship_city, c.contact_name FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id WHERE o.freight >= 40;
--+33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, concat(e.first_name, ' ', e.last_name) AS "full_name" FROM orders o 
	INNER JOIN employees e ON o.employee_id = e.employee_id 
		WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' GROUP BY o.order_date, o.ship_city,e.first_name,e.last_name;
--+34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT DISTINCT c.contact_name, c.phone FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id 
	WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31'; 	
	--+35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.contact_name, e.first_name , e.last_name  FROM orders o 
	INNER JOIN customers c ON o.customer_id = c.customer_id 
		INNER JOIN employees e ON o.employee_id = e.employee_id;
--+36. Geciken siparişlerim?
SELECT * FROM orders WHERE required_date < shipped_date OR shipped_date IS NULL;	
--+37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.order_date, c.contact_name FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id WHERE o.required_date < o.shipped_date;
--+38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM order_details od 
	INNER JOIN products p ON od.product_id = p.product_id 
		INNER JOIN categories c ON c.category_id = p.category_id WHERE od.order_id = 10248;
--+39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.contact_name FROM products p 
	INNER JOIN order_details od ON p.product_id = od.product_id 
		INNER JOIN suppliers s ON p.supplier_id = s.supplier_id WHERE od.order_id = 10248;
--+40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, od.quantity, e.employee_id FROM order_details od INNER JOIN products p ON p.product_id = od.product_id 
	INNER JOIN orders o ON od.order_id = o.order_id 
		INNER JOIN employees e ON e.employee_id = o.employee_id WHERE e.employee_id = 3 AND o.order_date BETWEEN '1997-01-01' AND '1997-12-31';
--+41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id,e.first_name,e.last_name,max(od.unit_price * od.quantity) AS "max_sale_only_once" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id 
		WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
			GROUP BY e.employee_id,e.first_name,e.last_name,od.quantity ORDER BY max(od.unit_price * od.quantity) DESC LIMIT 1;
--+42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id,e.first_name,e.last_name,sum(od.unit_price * od.quantity) AS "most_sale_in_1999" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id 
		WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
			GROUP BY e.employee_id,e.first_name,e.last_name,od.quantity ORDER BY sum(od.unit_price * od.quantity) DESC LIMIT 1;
--+43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products p 
	INNER JOIN categories c ON p.category_id = c.category_id ORDER BY p.unit_price DESC LIMIT 1;		
--+44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name,e.last_name,o.order_date,o.order_id FROM orders o 
	INNER JOIN employees e ON o.employee_id = e.employee_id ORDER BY o.order_date;
--+45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_date, avg(od.unit_price) AS "average_price", o.order_id FROM orders o 
	INNER JOIN order_details od ON o.order_id = od.order_id GROUP BY o.order_id,o.order_date ORDER BY o.order_date DESC LIMIT 5; 
--+46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT o.order_date, p.product_name , c.category_name ,sum(od.quantity) AS "total_sale_amount" FROM products p 
	INNER JOIN categories c ON p.category_id = c.category_id 
		INNER JOIN order_details od ON p.product_id = od.product_id 
			INNER JOIN orders o ON od.order_id = o.order_id 
					WHERE o.order_date BETWEEN '1997-01-01' AND '1997-01-31' OR o.order_date BETWEEN '1998-01-01' AND '1998-01-31'
						GROUP BY p.product_name , c.category_name, o.order_date
							ORDER BY o.order_date;
--+47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT p.product_name, od.quantity FROM order_details od INNER JOIN products p ON od.product_id = p.product_id 
	WHERE od.quantity > (SELECT avg(quantity) FROM order_details) ORDER BY od.quantity DESC;
--+48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.contact_name, sum(od.quantity) AS "Most_saled_product_in_terms_of_piece" FROM products p 
	INNER JOIN order_details od ON p.product_id = od.product_id 
		INNER JOIN suppliers s ON p.supplier_id = s.supplier_id 
			INNER JOIN categories c ON p.category_id = c.category_id
				GROUP BY p.product_name , c.category_name , s.contact_name ORDER BY sum(od.quantity) DESC LIMIT 1;
--+49. Kaç ülkeden müşterim var
SELECT count(DISTINCT c.country) AS "Country_numbers_of_customers"FROM customers c;
--+50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT sum(od.quantity) AS "sales_since_last_january" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id WHERE e.employee_id = 3 AND o.order_date > '1998-01-01'; 
--+51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM order_details od 
	INNER JOIN products p ON od.product_id = p.product_id 
		INNER JOIN categories c ON c.category_id = p.category_id WHERE od.order_id = 10248;
--+52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.contact_name FROM products p 
	INNER JOIN order_details od ON p.product_id = od.product_id 
		INNER JOIN suppliers s ON p.supplier_id = s.supplier_id WHERE od.order_id = 10248;
--+53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name,od.quantity,e.employee_id FROM products p INNER JOIN order_details od ON od.product_id = p.product_id 
	INNER JOIN orders o ON od.order_id = o.order_id 
		INNER JOIN employees e ON o.employee_id = e.employee_id WHERE e.employee_id = 3 AND o.order_date BETWEEN '1997-01-01' AND '1997-12-31';
--+54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id,e.first_name,e.last_name,max(od.unit_price * od.quantity) AS "max_sale_only_once" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id 
		WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
			GROUP BY e.employee_id,e.first_name,e.last_name,od.quantity ORDER BY max(od.unit_price * od.quantity) DESC LIMIT 1;	
--+55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id,e.first_name,e.last_name,sum(od.unit_price * (1-od.discount) *od.quantity) AS "most_sale_in_1999" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id 
		WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31' 
			GROUP BY e.employee_id,e.first_name,e.last_name,od.quantity ORDER BY sum(od.unit_price * (1-od.discount) * od.quantity) DESC LIMIT 1;
--+56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name FROM products p 
	INNER JOIN categories c ON p.category_id = c.category_id ORDER BY p.unit_price DESC LIMIT 1;	
--+57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name,e.last_name,o.order_date,o.order_id FROM orders o 
	INNER JOIN employees e ON o.employee_id = e.employee_id ORDER BY o.order_date;
--+58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_date, avg(od.unit_price) AS "average_price", o.order_id FROM orders o 
	INNER JOIN order_details od ON o.order_id = od.order_id GROUP BY o.order_id,o.order_date ORDER BY o.order_date DESC LIMIT 5; 
--+59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT o.order_date, p.product_name , c.category_name ,sum(od.quantity) AS "total_sale_amount" FROM products p 
	INNER JOIN categories c ON p.category_id = c.category_id 
		INNER JOIN order_details od ON p.product_id = od.product_id 
			INNER JOIN orders o ON od.order_id = o.order_id 
					WHERE o.order_date BETWEEN '1997-01-01' AND '1997-01-31' OR o.order_date BETWEEN '1998-01-01' AND '1998-01-31'
						GROUP BY p.product_name , c.category_name, o.order_date
							ORDER BY o.order_date;
--+60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT p.product_name, od.quantity FROM order_details od INNER JOIN products p ON od.product_id = p.product_id 
	WHERE od.quantity > (SELECT avg(quantity) FROM order_details) ORDER BY od.quantity DESC;
--+61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.contact_name, sum(od.quantity) AS "Most_saled_product_in_terms_of_piece" FROM products p 
	INNER JOIN order_details od ON p.product_id = od.product_id 
		INNER JOIN suppliers s ON p.supplier_id = s.supplier_id 
			INNER JOIN categories c ON p.category_id = c.category_id
				GROUP BY p.product_name , c.category_name , s.contact_name ORDER BY sum(od.quantity) DESC LIMIT 1;
--+62. Kaç ülkeden müşterim var
SELECT count(DISTINCT c.country) AS "Country_numbers_of_customers"FROM customers c;
--+63. Hangi ülkeden kaç müşterimiz var
SELECT c.country , count(*) AS "customer_numbers_from_different_countries" FROM customers c GROUP BY c.country ;
--+64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT sum(od.quantity) AS "sales_since_last_january" FROM order_details od INNER JOIN orders o ON od.order_id = o.order_id 
	INNER JOIN employees e ON o.employee_id = e.employee_id WHERE e.employee_id = 3 AND o.order_date > '1998-01-01'; 
--+65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT sum(od.unit_price * (1 - od.discount) *od.quantity) AS "revenue_last_3_months" FROM order_details od INNER JOIN products p ON od.product_id = p.product_id 
	INNER JOIN orders o ON o.order_id = od.order_id WHERE p.product_id = 10 AND o.order_date BETWEEN '1998-02-06' AND '1998-05-06';
--+66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.first_name, e.last_name, sum(od.quantity) AS "total_order_quantity" FROM employees e INNER JOIN orders o ON o.employee_id = e.employee_id 
	INNER JOIN order_details od ON o.order_id = od.order_id GROUP BY e.first_name , e.last_name ;
--+67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.contact_name,c.company_name,c.customer_id FROM orders o RIGHT JOIN customers c ON o.customer_id = c.customer_id WHERE o.order_id IS NULL;
--+68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT c.company_name,c.contact_name,c.address,c.city,c.country FROM customers c WHERE c.country = 'Brazil';
--+69. Brezilya’da olmayan müşteriler
SELECT * FROM customers c EXCEPT SELECT * FROM customers c WHERE c.country = 'Brazil';
--+70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers c WHERE c.country IN ('Spain','France','Germany');
--+71. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers c WHERE c.fax IS NULL;
--+72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT * FROM customers c WHERE c.city IN ('London','Paris');
--+73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers c WHERE c.contact_title = 'Owner' AND c.city = 'México D.F.';
--+74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT p.product_name, p.unit_price FROM products p WHERE p.product_name LIKE 'C%';
--+75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT e.first_name, e.last_name, e.birth_date FROM employees e WHERE e.first_name LIKE 'A%';
--+76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT c.company_name FROM customers c WHERE c.company_name LIKE '%Restaurant%';
--+77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT p.product_name, p.unit_price FROM products p WHERE p.unit_price BETWEEN 50 AND 100;
--+78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT o.order_id, o.order_date FROM orders o WHERE o.order_date BETWEEN '1996-06-01' AND '1996-12-31';
--+79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers c WHERE c.country IN ('Spain','France','Germany');
--+80. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers c WHERE c.fax IS NULL;
--+81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT * FROM customers c ORDER BY c.country; 
--+82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT p.product_name , p.unit_price FROM products p ORDER BY p.unit_price DESC;
--+83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT p.product_name , p.unit_price, p.units_in_stock FROM products p ORDER BY p.unit_price DESC, p.units_in_stock ASC;
--+84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT count(*) AS "product_number_from_category_one" FROM products p INNER JOIN categories c ON p.category_id = c.category_id WHERE c.category_id = 1;
--+85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT count(DISTINCT c.country) AS "exports_to_different_countries" FROM customers c ;
--+86. a.Bu ülkeler hangileri..?
SELECT DISTINCT c.country FROM customers c; 
--+87. En Pahalı 5 ürün
SELECT * FROM products p ORDER BY p.unit_price DESC LIMIT 5;
--+88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT count(*) AS "ALFKI_order_numbers" FROM orders o WHERE o.customer_id = 'ALFKI';
--+89. Ürünlerimin toplam maliyeti
SELECT sum(p.units_in_stock * p.unit_price) AS "total_cost" FROM products p ;
--+90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT sum(od.unit_price * (1 - od.discount) * od.quantity) AS "total_sum_until_now" FROM order_details od; 
--+91. Ortalama Ürün Fiyatım
SELECT avg(p.unit_price) "average_product_price" FROM products p;
--+92. En Pahalı Ürünün Adı
SELECT p.product_name FROM products p ORDER BY p.unit_price DESC LIMIT 1;
--+93. En az kazandıran sipariş
SELECT p.product_name , sum(od.unit_price * (1 - discount) * od.quantity) FROM order_details od 
	INNER JOIN products p ON od.product_id = p.product_id GROUP BY p.product_name ORDER BY sum(od.unit_price * (1 - discount) * od.quantity) LIMIT 1;
--+94. Müşterilerimin içinde en uzun isimli müşteri
SELECT c.contact_name FROM customers c;
--+95. Çalışanlarımın Ad, Soyad ve Yaşları
SELECT e.first_name, e.last_name, age(e.birth_date) FROM employees e GROUP BY e.first_name, e.last_name,e.birth_date;
--+96. Hangi üründen toplam kaç adet alınmış..?
SELECT p.product_name, sum(od.quantity) AS "bought_products_numbers" FROM order_details od 
	INNER JOIN products p ON od.product_id = p.product_id GROUP BY p.product_name;
--+97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT p.product_name, sum(od.unit_price * (1 - od.discount) * od.quantity) FROM order_details od 
	INNER JOIN products p ON od.product_id = p.product_id INNER JOIN orders o ON od.order_id = o.order_id GROUP BY p.product_name
		ORDER BY sum(od.unit_price * (1 - od.discount) * od.quantity) DESC;
--+98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT c.category_name, sum(p.units_in_stock) FROM products p INNER JOIN categories c ON p.category_id = c.category_id GROUP BY c.category_name ;
--+99. 1000 Adetten fazla satılan ürünler?
SELECT p.product_name, sum(od.quantity) AS "sales_more_than_1000" FROM order_details od INNER JOIN products p ON od.product_id = p.product_id 
	GROUP BY p.product_name HAVING sum(od.quantity) > 1000;
--+100. Hangi Müşterilerim hiç sipariş vermemiş..?
SELECT c.contact_name,c.company_name,c.customer_id FROM orders o RIGHT JOIN customers c ON o.customer_id = c.customer_id WHERE o.order_id IS NULL;