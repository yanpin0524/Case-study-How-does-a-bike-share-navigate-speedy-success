# Case study: How does a bike-share navigate speedy success?

# 1. Case Introduction

## Case Background

In 2016, Cyclistic launched a successful bike-share oering. Since then, the program has grown to a eet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.  

 Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the exibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.  

 Cyclistic’s nance analysts have concluded that annual members are much more protable than casual riders. Although the pricing exibility helps Cyclistic aract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a solid opportunity to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.  

 Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the team needs to beer understand how annual members and casual riders dier, why casual riders would buy a membership, and how digital media could aect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends. 

## What question I’m trying to answer
**Q: how do annual members and casual riders use Cyclistic bike differently?**

### How does these insights can help to drive business decisions?
> By delving into the behavioral patterns of annual members and casual riders, we can identify elements that resonate with them and understand the factors that lead casual riders to become annual members. This information can be used to optimize marketing strategies, such as promoting specific features or services that attract casual riders or designing personalized promotional activities for potential annual members.


----------
# 2. Preparing and Processing

## What tools were used for this analysis?
-   R-Language
-   R-Packages:
    -   tidyverse
    -   ggplot2
    -   scales
    -   dplyr
    -   hms
    -   DescTools

## What data used for this analysis?

-   **Data Name:** _Cyclistic Trip Data_
-   **Source:** [Cyclistic Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)
-   **Time Interval:** December 2022 to November 2023
> _Note: The datasets have a different name because Cyclistic is a fictional company. However, for the purposes of this case study, these datasets are appropriate and will enable you to answer the business questions. The data has been made available by Motivate International Inc. under this license._

  
## Data Preparing
### Import cyclistic_trip_datas from 2022-12 to 2023-11
```r

cyclistic_trip_data_202212 <- read_csv("202212-divvy-tripdata.csv")
cyclistic_trip_data_202301 <- read_csv("202301-divvy-tripdata.csv")
cyclistic_trip_data_202302 <- read_csv("202302-divvy-tripdata.csv")
...
cyclistic_trip_data_202311 <- read_csv("202311-divvy-tripdata.csv")

```

### Combine all data into one data frame
```r

cyclistic_trip_datas <- rbind(cyclistic_trip_data_202212, cyclistic_trip_data_202301, cyclistic_trip_data_202302, cyclistic_trip_data_202303, cyclistic_trip_data_202304, cyclistic_trip_data_202305, cyclistic_trip_data_202306, cyclistic_trip_data_202307, cyclistic_trip_data_202308, cyclistic_trip_data_202309, cyclistic_trip_data_202310, cyclistic_trip_data_202311)

```


## Data Preprocessing

1.  Remove incomplete data
```r

cleaned_cyclistic_trip_datas <- na.omit(cyclistic_trip_datas)

```

1.  Create columns for ride length, day of the week, month, and quarter, and hour of day columns to calculate ride length and the day of the week
```r

preprocessed_cyclistic_trip_datas <- cleaned_cyclistic_trip_datas %>%
  mutate(
    ride_length = as_hms(ended_at - started_at),  # Calculate ride length
    day_of_week = format(started_at, "%A"),       # Extract day of the week
    month = format(started_at, "%Y%m"),           # Extract month in YYYYMM format
    quarter = quarters(started_at),               # Extract quarter
    hour_of_day = hour(started_at)                # Extract hour of day
  )

```

1.  Change the sorting of the day_of_week column to the correct order
```r

preprocessed_cyclistic_trip_datas$day_of_week <- factor(preprocessed_cyclistic_trip_datas$day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

```


----------
# 3. Start Analyzing
To answer the question *"How do annual members and casual riders use Cyclist bikes differently?"*, I analyzed and observed a couple of aspects.

First, I examined whether annual members and casual riders differed in peak bike usage times, including the season of the year, time of day, and day of the week. Then, I looked at whether there were differences in bike ride length between annual members and casual riders.

These observations aim to gain a comprehensive understanding of the distinctions in bike usage between annual members and casual riders, laying the groundwork for further analysis and conclusions.

### Here is what I found in this analysis:

1. The distribution of quarterly trips indicates whether members or casual riders are more willing to use bikes in the third quarter (Q3).
![enter image description here](https://i.imgur.com/66kHkI7.png)
![enter image description here](https://i.imgur.com/LO4m8bP.png)

2. The weekly distribution shows that annual members' peak usage is on Tuesdays, Wednesdays, and Thursdays, while casual riders peak on Saturdays.
![enter image description here](https://i.imgur.com/nMnx8YB.png)

3. Annual members tended to use bikes during typical commuting hours, whereas casual riders were more active in the afternoons.
![enter image description here](https://i.imgur.com/22UyHk8.png)

4. But as I explored further, I discovered, that on weekends, peak usage times of the day for annual members shifted to the afternoon, while casual riders showed consistent patterns on both weekdays and weekends.
![enter image description here](https://i.imgur.com/ePjTssy.png)

5. Lastly, I found that casual riders exhibited significantly longer average ride durations compared to annual members, indicating a distinct difference in the time spent on bike rides.
![enter image description here](https://i.imgur.com/JIMRofx.png)


---
# 4. Recommendation and Next Step
Based on findings, here are some insights and recommendations:

1. **Peak Period Considerations:**
   - Given that annual members exhibit higher usage on Tuesdays, Wednesdays, and Thursdays, consider increasing bike availability on these days to meet their demand.
   - The significant increase in casual ridership on Saturdays, likely driven by leisure activities, suggests an opportunity to offer special events or promotions on this day to attract more casual riders.

2. **Distribution of Peak Periods Throughout the Day:**
   - Understanding that annual members predominantly use bikes during commute hours, consider enhancing services during these periods, such as increasing the number of stations or bikes available.
   - With casual riders showing a concentration in afternoon usage, align marketing efforts during this time to attract more casual riders seeking leisurely bike rides.

3. **Usage Patterns Between Members and Non-Members:**
   - Recognizing that casual riders tend to have longer average ride durations, it implies a preference for extended bike riding experiences. Consider providing more diverse route options and enhancing comfort features to cater to their needs.
   - For annual members, who likely prioritize shorter commuting needs, explore options to offer quicker, convenient ride choices to accommodate their brief commuting requirements.
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNzMwMjEwMDJdfQ==
-->