# ============================================
# LAB 3: Factory Pattern
# ============================================
# The Factory pattern provides an interface for creating objects
# without specifying their exact classes.
# Run this file with: ruby factory.rb

# Exercise 1: Simple Factory for creating different types of vehicles
# Implement a VehicleFactory that creates Cars, Motorcycles, and Trucks

class Vehicle
  attr_reader :type, :wheels, :capacity
  
  def initialize(type, wheels, capacity)
    @type = type
    @wheels = wheels
    @capacity = capacity
  end
  
  def description
    "#{@type} with #{@wheels} wheels, capacity: #{@capacity} passengers"
  end
end

class Car < Vehicle
  def initialize
    # TODO: Call super with appropriate values
    # Car: 4 wheels, 5 passengers
    super("Car", 4, 5)
  end
end

class Motorcycle < Vehicle
  def initialize
    # TODO: Call super with appropriate values
    # Motorcycle: 2 wheels, 2 passengers
    super("Motorcycle", 2, 2)
  end
end

class Truck < Vehicle
  def initialize
    # TODO: Call super with appropriate values
    # Truck: 6 wheels, 3 passengers
    super("Truck", 6, 3)
  end
end

class VehicleFactory
  # TODO: Implement create_vehicle method
  # It should take a symbol (:car, :motorcycle, or :truck)
  # and return an instance of the appropriate class
  # Return nil for unknown types
  
  def self.create_vehicle(type)
    case type
    when :car
      Car.new
    when :motorcycle
      Motorcycle.new
    when :truck
      Truck.new
    else
      nil
    end
  end
end

# Exercise 2: Factory Method Pattern
# Create different types of notifications (Email, SMS, Push)

class Notification
  def send(message)
    raise NotImplementedError, "Subclasses must implement send method"
  end
end

class EmailNotification < Notification
  # TODO: Implement send method
  # Return "Email sent: #{message}"
  def send(message)
    "Email sent: #{message}"
  end
end

class SMSNotification < Notification
  # TODO: Implement send method
  # Return "SMS sent: #{message}"
  def send(message)
    "SMS sent: #{message}"
  end
end

class PushNotification < Notification
  # TODO: Implement send method
  # Return "Push notification sent: #{message}"
  def send(message)
    "Push notification sent: #{message}"
  end
end

class NotificationFactory
  # TODO: Create a factory method that returns appropriate notification
  # Input: type (:email, :sms, :push)
  # Output: instance of appropriate notification class
  
  def self.create(type)
    case type
    when :email
      EmailNotification.new
    when :sms
      SMSNotification.new
    when :push
      PushNotification.new
    else
      nil
    end
  end
end

# Exercise 3: Abstract Factory Pattern
# Create UI elements for different themes (Light and Dark)

module UIElement
  def render
    raise NotImplementedError
  end
end

class LightButton
  include UIElement
  
  # TODO: Implement render method
  # Return "Rendering light button"
  def render
    nil
  end
end

class DarkButton
  include UIElement
  
  # TODO: Implement render method
  # Return "Rendering dark button"
  def render
    nil
  end
end

class LightTextField
  include UIElement
  
  # TODO: Implement render method
  # Return "Rendering light text field"
  def render
    nil
  end
end

class DarkTextField
  include UIElement
  
  # TODO: Implement render method
  # Return "Rendering dark text field"
  def render
    nil
  end
end

class ThemeFactory
  def create_button
    raise NotImplementedError
  end
  
  def create_text_field
    raise NotImplementedError
  end
end

class LightThemeFactory < ThemeFactory
  # TODO: Implement create_button to return LightButton
  # TODO: Implement create_text_field to return LightTextField
  
  def create_button
    nil
  end
  
  def create_text_field
    nil
  end
end

class DarkThemeFactory < ThemeFactory
  # TODO: Implement create_button to return DarkButton
  # TODO: Implement create_text_field to return DarkTextField
  
  def create_button
    nil
  end
  
  def create_text_field
    nil
  end
end

# ============================================
# TEST CASES - Do not modify below this line
# ============================================

def run_tests
  tests_passed = 0
  total_tests = 0
  
  puts "Testing Factory Pattern..."
  puts "=" * 40
  
  # Test 1: VehicleFactory creates Car
  total_tests += 1
  begin
    car = VehicleFactory.create_vehicle(:car)
    if car.is_a?(Car) && car.wheels == 4 && car.capacity == 5
      tests_passed += 1
      puts "✓ Test 1 passed: VehicleFactory creates Car"
    else
      puts "✗ Test 1 failed: Car not created correctly"
    end
  rescue => e
    puts "✗ Test 1 failed: #{e.message}"
  end
  
  # Test 2: VehicleFactory creates Motorcycle
  total_tests += 1
  begin
    motorcycle = VehicleFactory.create_vehicle(:motorcycle)
    if motorcycle.is_a?(Motorcycle) && motorcycle.wheels == 2
      tests_passed += 1
      puts "✓ Test 2 passed: VehicleFactory creates Motorcycle"
    else
      puts "✗ Test 2 failed: Motorcycle not created correctly"
    end
  rescue => e
    puts "✗ Test 2 failed: #{e.message}"
  end
  
  # Test 3: VehicleFactory creates Truck
  total_tests += 1
  begin
    truck = VehicleFactory.create_vehicle(:truck)
    if truck.is_a?(Truck) && truck.wheels == 6
      tests_passed += 1
      puts "✓ Test 3 passed: VehicleFactory creates Truck"
    else
      puts "✗ Test 3 failed: Truck not created correctly"
    end
  rescue => e
    puts "✗ Test 3 failed: #{e.message}"
  end
  
  # Test 4: NotificationFactory creates EmailNotification
  total_tests += 1
  begin
    email = NotificationFactory.create(:email)
    result = email.send("Hello")
    if result == "Email sent: Hello"
      tests_passed += 1
      puts "✓ Test 4 passed: Email notification works"
    else
      puts "✗ Test 4 failed: Email notification incorrect"
    end
  rescue => e
    puts "✗ Test 4 failed: #{e.message}"
  end
  
  # Test 5: NotificationFactory creates SMSNotification
  total_tests += 1
  begin
    sms = NotificationFactory.create(:sms)
    result = sms.send("Test")
    if result == "SMS sent: Test"
      tests_passed += 1
      puts "✓ Test 5 passed: SMS notification works"
    else
      puts "✗ Test 5 failed: SMS notification incorrect"
    end
  rescue => e
    puts "✗ Test 5 failed: #{e.message}"
  end
  
  # Test 6: NotificationFactory creates PushNotification
  total_tests += 1
  begin
    push = NotificationFactory.create(:push)
    result = push.send("Alert")
    if result == "Push notification sent: Alert"
      tests_passed += 1
      puts "✓ Test 6 passed: Push notification works"
    else
      puts "✗ Test 6 failed: Push notification incorrect"
    end
  rescue => e
    puts "✗ Test 6 failed: #{e.message}"
  end
  
  # Test 7: LightThemeFactory creates light UI elements
  total_tests += 1
  begin
    factory = LightThemeFactory.new
    button = factory.create_button
    text_field = factory.create_text_field
    
    if button.render == "Rendering light button" && 
       text_field.render == "Rendering light text field"
      tests_passed += 1
      puts "✓ Test 7 passed: LightThemeFactory works"
    else
      puts "✗ Test 7 failed: Light theme elements incorrect"
    end
  rescue => e
    puts "✗ Test 7 failed: #{e.message}"
  end
  
  # Test 8: DarkThemeFactory creates dark UI elements
  total_tests += 1
  begin
    factory = DarkThemeFactory.new
    button = factory.create_button
    text_field = factory.create_text_field
    
    if button.render == "Rendering dark button" && 
       text_field.render == "Rendering dark text field"
      tests_passed += 1
      puts "✓ Test 8 passed: DarkThemeFactory works"
    else
      puts "✗ Test 8 failed: Dark theme elements incorrect"
    end
  rescue => e
    puts "✗ Test 8 failed: #{e.message}"
  end
  
  puts "\n" + "=" * 40
  if tests_passed == total_tests
    puts "🎉 All tests passed! (#{tests_passed}/#{total_tests})"
    puts "Great! You've mastered the Factory pattern!"
  else
    puts "Tests passed: #{tests_passed}/#{total_tests}"
    puts "Keep working on the remaining exercises."
  end
  puts "=" * 40
end

# Run the tests
run_tests
