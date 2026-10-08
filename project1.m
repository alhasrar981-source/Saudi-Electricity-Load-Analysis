%% Saudi Arabia Electricity Load Analysis

clear;
clc;
close all;


%% 1. Import Data

data = readtable('saudi-arabia-electricity-load-monthly-by-region (1).csv', 'Delimiter', ';');

head(data)


%% 2. Inspect Data

size(data)

summary(data)

%% 3. Explore Electricity Load Indicators

unique(data.Indicator)


%% 4. Create Region and Load Type Variables

data.Region = strings(height(data),1);
data.LoadType = strings(height(data),1);

data.Region(contains(data.Indicator,'Central')) = "Central";
data.Region(contains(data.Indicator,'Eastern')) = "Eastern";
data.Region(contains(data.Indicator,'Southern')) = "Southern";
data.Region(contains(data.Indicator,'Western')) = "Western";

data.LoadType(contains(data.Indicator,'Average')) = "Average";
data.LoadType(contains(data.Indicator,'Maximum')) = "Maximum";
data.LoadType(contains(data.Indicator,'Minimum')) = "Minimum";

head(data)


%% 5. Regional Average Load Analysis

averageData = data(data.LoadType == "Average", :);

regionalMean = groupsummary(averageData, "Region", "mean", "Value");

regionalMean


%% 6. Regional Average Load Visualization

figure

bar(regionalMean.mean_Value)

xticks(1:4)
xticklabels(regionalMean.Region)

xlabel('Region')
ylabel('Average Load (GW)')
title('Average Electricity Load by Region')

grid on


%% 7. Eastern Region Trend

averageData = data(data.LoadType == "Average", :);

easternData = averageData(averageData.Region == "Eastern", :);


%% 8. Convert Date to Numeric

dateText = string(easternData.Date);

yearValue = str2double(extractBefore(dateText, "-"));
monthValue = str2double(extractAfter(dateText, "-"));

dateNumber = yearValue + (monthValue - 1) / 12;


%% 9. Sort Data by Date

[dateNumber, order] = sort(dateNumber);

loadValue = easternData.Value(order);


%% 10. Plot Eastern Region Trend

figure

plot(dateNumber, loadValue, 'LineWidth', 1.5)

xlabel('Year')
ylabel('Average Load (GW)')
title('Eastern Region Average Electricity Load')

grid on