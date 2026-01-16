Create database airportdetails_db;

use airportdetails_db;

select * from airports;


-- Problem 1 # Frequent Route

select 
origin_airport,
Destination_airport,
SUM(Passengers) as Total_Passengers
from airports
group by origin_airport, Destination_airport
order by Total_Passengers Desc ;


-- Problem 2 # Average Seat Utilization 

select 
origin_airport,
Destination_airport,
round(avg(cast(Passengers as float)/nullif(Seats,0)) * 100,2) as Average_seat_utilization
from airports
group by origin_airport, Destination_airport
order by Average_seat_utilization Desc ;


-- Problem 3 # Find Out Most Active city

select
origin_city,
count(Flights) as Total_Flights,
sum(Passengers) as Total_Passengers
from airports
group by origin_city
order by Total_Passengers Desc;


-- Problem 4 # Calculate total distance (Travel Pattern)

select
origin_airport,
sum(distance) as total_distance
from airports
group by origin_airport
order by total_distance desc;


-- Problem 5 # Calculate Seasonal Trend

select
year(Fly_date) as Year,
month(Fly_date) as Month,
count(Flights) as Total_Flights,
sum(Passengers) as Total_Passengers,
round(avg(Distance),2) as Average_Distance
from airports
group by Year, Month
order by Year Desc, Month Desc ;


-- Problem 6 # UnderUtilized Routes

select
origin_airport,
Destination_airport,
sum(Passengers) as Total_Passengers,
sum(Seats) as Total_Seats,
sum(cast(Passengers as float) / nullif(Seats,0)) as Passengers_to_Seats_Ratio
from airports
group by origin_airport, Destination_airport
having Passengers_to_Seats_Ratio < 0.5
order by Passengers_to_Seats_Ratio ;


-- Problem 7 # Most Active Airport

select 
origin_airport,
count(Flights) as Total_Flights
from airports
group by origin_airport
order by Total_FLights desc;


-- Problem 8 # Travelling to Particular City

select 
origin_city,
count(Flights) as Total_Flights,
sum(Passengers) as Total_Passengers
from airports
where Destination_city = "Bend, OR" and Origin_city <> "Bend, OR"
group by origin_city
order by Total_Passengers Desc
limit 3;


-- Problem 9 # Maximum Distance Travel By Flight

select 
origin_airport,
Destination_airport,
max(Distance) as Maximum_Distance
from airports
group by origin_airport, Destination_airport
order by Maximum_Distance Desc
limit 3;


-- Problem 10 # Seasonal Trend in Flights Monthly/Yearly

With Monthly_Flights as 
(select
month(Fly_date) as month,
count(Flights) as Total_Flights
from airports
group by month(Fly_date)
)

select
	month,
    Total_Flights,
    CASE 
		When Total_Flights = (select max(Flights) from Monthly_Flights) then 'Most Busy'
        When Total_Flights = (select min(Flights) from Monthly_Flights) then 'Least Busy'
        ELSE NULL
	End as Status
from Monthly_Flights
where 
	Total_Flights = (select max(Flights) from Monthly_Flights) OR
	Total_Flights = (select min(Flights) from Monthly_Flights) ;


-- Problem 11 # Passenger Traffic Trends

With Passengers_Summary as
(select
origin_airport,
Destination_airport,
Year(Fly_date) as Year,
sum(Passengers) as Total_Passengers
from airports
group by origin_airport, Destination_airport, Year(Fly_date)
),

Passenger_Growth as
(select
origin_airport,
Destination_airport,
Year,
Total_Passengers,
lag(Total_Passengers) over (Partition by origin_airport,Destination_airport order by Year) as Previous_Year_Passengers
from Passengers_Summary )

select
origin_airport,
Destination_airport,
Year,
Total_Passengers,
Case
	WHEN Previous_Year_Passengers is not null then
    ((Total_Passengers - Previous_Year_Passengers)* 100.0 / nullif(Previous_Year_Passengers,0))
End as Growth_Percentage
from Passenger_Growth
order by origin_airport,Destination_airport,Year;


-- Problem 12 # Trending Flights/ Growth Rate of Flights

With Flight_Summary as
(select
origin_airport,
Destination_airport,
Year(Fly_date) as Year,
count(Flights) as Total_Flights
from  airports
group by origin_airport,Destination_airport,Year(Fly_date)),

Flight_Growth as
(select
origin_airport,
Destination_airport,
Year,
Total_Flights,
lag(Total_Flights) over (partition by origin_airport,Destination_airport order by Year) as Previous_Year_Flights
from Flight_Summary),

Growth_Rate as 
(select
origin_airport,
Destination_airport,
Year,
Total_Flights,
Case
	WHEN Previous_Year_Flights is not null AND Previous_Year_Flights >0 then
    ((Total_Flights - Previous_Year_Flights)*100.0/Previous_Year_Flights)
    ELSE null
End as Growth_Rate,
Case
	WHEN Previous_Year_Flights is not null AND Total_Flights > Previous_Year_Flights then
    1
    ELSE 0
End as Growth_Indicator
from Flight_Growth )

select 
origin_airport,
Destination_airport,
min(Growth_Rate) as Minimum_Growth_Rate,
max(Growth_Rate) as Maximum_Growth_Rate
from Growth_Rate
where Growth_Indicator = 1
group by origin_airport,Destination_airport
having min(Growth_Indicator) = 1
order by origin_airport, Destination_airport ;


-- Problem 13 # Passenger to Seat Ratio/ Flight Volume

with Utilization_Ratio as
(select
origin_airport,
sum(Passengers) as Total_Passengers,
sum(Seats) as Total_Seats,
count(Flights) as Total_Flights,
sum(Passengers) * 1.0 / sum(Seats) as Passengers_Seat_Ratio
from airports
group by origin_airport ),

Weighted_Utilization as
(select
origin_airport,
Total_Passengers,
Total_Seats,
Total_Flights,
Passengers_Seat_Ratio,
(Passengers_Seat_Ratio * Total_Flights) / sum(Total_Flights) over () as Weighted_Utilization
from Utilization_Ratio )

select
origin_airport,
Total_Passengers,
Total_Seats,
Total_Flights,
Weighted_Utilization
from Weighted_Utilization
order by Weighted_Utilization desc
limit 5;


-- Problem 14 # Seasonal Travel Pattern Based on SPecific City

With Monthaly_Passeneger_Count as
(select
origin_city,
year(Fly_date) as Year,
month(Fly_date) as Month,
sum(Passengers) as Total_Passengers
from airports
group by origin_city,Year,Month ),

Max_Passeneger_Per_City as 
(select
origin_city,
max(Total_Passengers) as Peak_Passenger
from Monthaly_Passeneger_Count
group by origin_city )

select
mpc.origin_city,
mpc.Year,
mpc.Month,
mpc.Total_Passengers
from Monthaly_Passeneger_Count mpc
join Max_Passeneger_Per_City mp
on mpc.origin_city = mp.origin_city and
mpc.Total_Passengers = mp.Peak_Passenger
order by mpc.origin_city,mpc.Year,mpc.Month;


-- Problem 15 # Identify Declined Routes Yearly

With Yearly_Passengers_Count as 
(select
origin_airport,
Destination_airport,
year(Fly_date)as Year,
sum(Passengers) as Total_Passengers
from airports
group by origin_airport,
Destination_airport, Year ),

Yearly_Decline as 
(select
y1.origin_airport,
y1.Destination_airport,
y1.Year Year1,
y1.Total_Passengers as Passengers_Year1,
y2.Year Year2,
y2.Total_Passengers as Passengers_Year2,
((y2.Total_Passengers - y1.Total_Passengers) / nullif(y1.Total_Passengers,0)) * 100 as Percentage_Change
from Yearly_Passengers_Count y1
join Yearly_Passengers_Count y2
on y1.origin_airport = y2.origin_airport and
	y1.Destination_airport = y2.Destination_airport and
    y1.Year = y2.Year+1 )
    
select 
origin_airport,
Destination_airport,
Year1,
Passengers_Year1,
Year2,
Passengers_Year2,
Percentage_Change
from Yearly_Decline
where Percentage_Change<0
order by Percentage_Change
limit 5 ;


-- Problem 16 # Highlight Underperforming Routes

with Flight_Stats as 
(select
origin_airport,
Destination_airport,
count(Flights) as Total_Flights,
sum(Passengers) as Total_Passengers,
sum(Seats) as Total_Seats,
(sum(Passengers) / nullif(sum(Seats),0)) as Avg_Seat_Utilization
from airports
group by origin_airport, Destination_airport)

select
origin_airport,
Destination_airport,
Total_Flights,
Total_Passengers,
Total_Seats,
round((Avg_Seat_Utilization * 100),2) as Avg_Seat_Utilization_Percentage
from Flight_Stats
where Total_Flights>10 and
	  round((Avg_Seat_Utilization * 100),2)  < 50
order by Avg_Seat_Utilization_Percentage ;


-- Problem 17 # Insights Into Long-Haul Travel Pattern

with Distance_Stats as 
(select
Origin_airport,
Destination_airport,
avg(Distance) as Avg_Flight_Distance
from airports
group by Origin_airport,Destination_airport)

select
Origin_airport,
Destination_airport,
round(Avg_Flight_Distance,2) as Avg_Flight_Distance
from Distance_Stats
order by Avg_Flight_Distance desc;


-- Problem 18 # Overview of Annual Trend

with Yearly_Summary as
(select
year(Fly_date)as Year,
count(Flights) as Total_Flights,
sum(Passengers) as Total_Passengers
from airports
group by Year ),

Yearly_Growth as 
(select
Year,
Total_Flights,
Total_Passengers,
lag(Total_Flights) over (order by Year) as Previous_Flights,
lag(Total_Passengers) over (order by Year) as Previous_Passengers
from Yearly_Summary )

select
Total_Flights,
Total_Passengers,
round(((Total_Flights - Previous_Flights)/nullif(Previous_Flights,0)* 100),2) as Flight_Growth_Percentage,
round(((Total_Passengers - Previous_Passengers)/nullif(Previous_Passengers,0)* 100),2) as Passenger_Growth_Percentage
from Yearly_Growth
order by Year;


-- Problem 19 # Most Significent Route Distance/ Operational Activities

with Route_Distance as
(select
origin_airport,
Destination_airport,
sum(Flights) as Total_Flights,
sum(Distance) as Total_Distance
from airports
group by origin_airport,Destination_airport ),

Weighted_Route as 
(select 
origin_airport,
Destination_airport,
Total_Flights,
Total_Distance,
Total_Distance * Total_Flights as Weighted_Distance
from Route_Distance )

select
origin_airport,
Destination_airport,
Total_Flights,
Total_Distance,
Weighted_Distance
from Weighted_Route
order by Weighted_Distance Desc
limit 3 ;






