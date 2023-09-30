
#1 find the travel guide's name that the agency has used for German destinations
SELECT e.name , e.surname
FROM employees e, guided_tour g, tourist_attraction ta, destination d
WHERE e.employees_AM = g.travel_guide_employee_AM
  and g.tourist_attraction_id = ta.tourist_attraction_id
  and ta.destination_destination_id = d.destination_id
  and d.country = 'Germany'
group by e.name , e.surname;

#2 Find the travel guide's am with more than 3 tours in 2019
SELECT e.employees_AM, count(g.trip_package_id) number_of_guided_tours
FROM employees e, guided_tour g, trip_package t
WHERE e.employees_AM = g.travel_guide_employee_AM 
and t.trip_start >= '2019-01-01' and t.trip_end<='2019-12-31' and 
g.trip_package_id = t.trip_package_id
group by e.employees_AM
having count(g.trip_package_id) > 3;

# 3 Find the number of employees each travel agency branch has.
SELECT t.travel_agency_branch_id, count(t.travel_agency_branch_id) AS "Number of employees"
FROM employees e, travel_agency_branch t
WHERE t.travel_agency_branch_id = e.travel_agency_branch_travel_agency_branch_id
group by t.travel_agency_branch_id;

#4 Find the travel packages and the number of reservations made for them in the period '2021-01-01' to '2021-12-31' with Paris as the destination.
SELECT distinct t.trip_package_id ,count(r.Reservation_id) as reservations
FROM trip_package t, reservation r, destination d, trip_package_has_destination td
WHERE  t.trip_package_id = r.offer_trip_package_id 
and td.trip_package_trip_package_id = t.trip_package_id 
and td.destination_destination_id = d.destination_id 
and d.name = "paris"
and t.trip_start >= '2021-01-01' and t.trip_end<='2021-12-31' 
group by t.trip_package_id,d.name;

#5 Find the guides who have conducted all tours in the same language.
SELECT  e.name, e.surname
from employees e, guided_tour tour
where e.employees_AM = tour.travel_guide_employee_AM
group by e.employees_AM
having count(distinct tour.travel_guide_language_id) = 1;

# 6 Check if there has been an offer from the travel agency that was not used by anyone.
# The answer should return as a relationship with a tuple and a column with a value of "yes" or "no". 
#The use of Flow Control Operators (e.g., if, case, etc.) is prohibited.
SELECT distinct result_of.result
FROM ( SELECT distinct 'YES' AS result 
FROM (SELECT t.trip_package_id
FROM trip_package t, reservation r
WHERE t.trip_start >= '2020-01-01' and t.trip_end<='2020-12-31' 
group by t.trip_package_id
having count(r.Reservation_id) = 0) AS positive
UNION
SELECT distinct 'NO' AS result 
FROM (SELECT t.trip_package_id
FROM trip_package t, reservation r
WHERE t.trip_start >= '2020-01-01' and t.trip_end<='2020-12-31' 
group by t.trip_package_id
having count(r.Reservation_id) <> 0) AS negative
)AS result_of;

#7 Find all male travelers who are 40 years old or older and have made reservations for more than 3 travel packages.
SELECT t.name, t.surname
FROM traveler t, reservation r,trip_package tr
WHERE t.age >= 40 and t.gender = 'male' and t.traveler_id = r.Customer_id and r.offer_trip_package_id = tr.trip_package_id
group by t.name, t.surname
having count(r.Reservation_id) > 3;

# 8 Find the names of the guides who speak English and the number of tourist attractions 
#that have been visited on any tour by each guide in the above-mentioned language.
SELECT e.employees_AM,e.name,e.surname, count(ta.tourist_attraction_id)
FROM employees e, tourist_attraction ta, guided_tour gt, travel_guide_has_languages tgl , languages l
WHERE e.employees_AM = gt.travel_guide_employee_AM
and tgl.travel_guide_employee_AM = e.employees_AM
and tgl.languages_id = l.languages_id and l.name = 'English'
and gt.travel_guide_language_id = l.languages_id
and ta.tourist_attraction_id = gt.tourist_attraction_id
Group by e.employees_AM,e.name, e.surname;

#9 Find the country of the "destination" that is included in more travel packages than any other.
SELECT d.country
FROM destination d
WHERE (SELECT count(distinct td.trip_package_trip_package_id)
    FROM trip_package_has_destination td
    WHERE td.destination_destination_id = d.destination_id) >= ALL (SELECT count(distinct td.trip_package_trip_package_id)
																	FROM trip_package_has_destination td
																	group by td.destination_destination_id);


#10 Find the codes of the travel packages that include all the travel destinations related to Ireland.
SELECT t.trip_package_id
from trip_package t, trip_package_has_destination td, destination d
where t.trip_package_id = td.trip_package_trip_package_id
and td.destination_destination_id = d.destination_id
and d.country = 'ireland' 
group by t.trip_package_id
having count(distinct d.destination_id) = 5;



