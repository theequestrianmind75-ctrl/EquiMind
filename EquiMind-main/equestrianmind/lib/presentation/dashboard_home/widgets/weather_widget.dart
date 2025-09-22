import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic>? weatherData;
  final VoidCallback? onRefresh;

  const WeatherWidget({
    Key? key,
    this.weatherData,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'wb_sunny',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Riding Conditions',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onRefresh,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            weatherData == null ? _buildLoadingState() : _buildWeatherContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final temperature = (weatherData!['temperature'] as int?) ?? 22;
    final condition = (weatherData!['condition'] as String?) ?? 'Partly Cloudy';
    final humidity = (weatherData!['humidity'] as int?) ?? 65;
    final windSpeed = (weatherData!['windSpeed'] as int?) ?? 8;
    final visibility = (weatherData!['visibility'] as int?) ?? 10;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${temperature}°C',
                    style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                  Text(
                    condition,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: _getWeatherIcon(condition),
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 48,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildWeatherMetric(
                'Humidity',
                '${humidity}%',
                'water_drop',
                _getHumidityColor(humidity),
              ),
            ),
            Expanded(
              child: _buildWeatherMetric(
                'Wind',
                '${windSpeed} km/h',
                'air',
                _getWindColor(windSpeed),
              ),
            ),
            Expanded(
              child: _buildWeatherMetric(
                'Visibility',
                '${visibility} km',
                'visibility',
                _getVisibilityColor(visibility),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: _getRidingConditionColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getRidingConditionColor().withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: _getRidingConditionIcon(),
                color: _getRidingConditionColor(),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRidingConditionTitle(),
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getRidingConditionColor(),
                      ),
                    ),
                    Text(
                      _getRidingConditionDescription(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getRidingConditionColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherMetric(
      String label, String value, String iconName, Color color) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 20.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(height: 2.h),
            Text(
              'Loading weather data...',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'partly cloudy':
      case 'cloudy':
        return 'cloud';
      case 'rainy':
      case 'rain':
        return 'umbrella';
      case 'stormy':
        return 'thunderstorm';
      case 'windy':
        return 'air';
      default:
        return 'wb_cloudy';
    }
  }

  Color _getHumidityColor(int humidity) {
    if (humidity < 40) return AppTheme.lightTheme.colorScheme.tertiary;
    if (humidity > 80) return AppTheme.lightTheme.colorScheme.error;
    return AppTheme.lightTheme.colorScheme.secondary;
  }

  Color _getWindColor(int windSpeed) {
    if (windSpeed < 10) return AppTheme.lightTheme.colorScheme.secondary;
    if (windSpeed > 25) return AppTheme.lightTheme.colorScheme.error;
    return AppTheme.lightTheme.colorScheme.tertiary;
  }

  Color _getVisibilityColor(int visibility) {
    if (visibility < 5) return AppTheme.lightTheme.colorScheme.error;
    if (visibility > 15) return AppTheme.lightTheme.colorScheme.secondary;
    return AppTheme.lightTheme.colorScheme.tertiary;
  }

  Color _getRidingConditionColor() {
    if (weatherData == null)
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant;

    final temperature = (weatherData!['temperature'] as int?) ?? 22;
    final windSpeed = (weatherData!['windSpeed'] as int?) ?? 8;
    final condition = (weatherData!['condition'] as String?) ?? 'Partly Cloudy';

    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('storm') ||
        windSpeed > 25 ||
        temperature < 5 ||
        temperature > 35) {
      return AppTheme.lightTheme.colorScheme.error;
    }

    if (windSpeed > 15 || temperature < 10 || temperature > 30) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }

    return AppTheme.lightTheme.colorScheme.secondary;
  }

  String _getRidingConditionIcon() {
    final color = _getRidingConditionColor();
    if (color == AppTheme.lightTheme.colorScheme.error) return 'warning';
    if (color == AppTheme.lightTheme.colorScheme.tertiary) return 'info';
    return 'check_circle';
  }

  String _getRidingConditionTitle() {
    final color = _getRidingConditionColor();
    if (color == AppTheme.lightTheme.colorScheme.error)
      return 'Poor Conditions';
    if (color == AppTheme.lightTheme.colorScheme.tertiary)
      return 'Fair Conditions';
    return 'Excellent Conditions';
  }

  String _getRidingConditionDescription() {
    final color = _getRidingConditionColor();
    if (color == AppTheme.lightTheme.colorScheme.error)
      return 'Consider indoor training or postponing ride';
    if (color == AppTheme.lightTheme.colorScheme.tertiary)
      return 'Good for experienced riders, take extra care';
    return 'Perfect weather for riding. Horse will be comfortable';
  }
}
