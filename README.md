### Hi 
### task 1 with dart 
List customMapping(List list, int Function(int) callback, {bool mutate = false}) {
  List result = List.from(list);

  if (mutate) {
    for (int i = 0; i < result.length; i++) {
      result[i] = callback(result[i]);
    }
  } else {
    result = result.map((element) => callback(element)).toList();
  }

  return result;
}

void main() {
  List originalList = [1, 2, 3, 4];
  List mappedList = customMapping(originalList, (element) => element * 2, mutate: false);

  print(mappedList); // Output: [2, 4, 6, 8]
}
### task 1 with ruby
def custom_mapping(list, callback, mutate: false)
  result = list.dup

  if mutate
    (0...result.length).each { |i| result[i] = callback.call(result[i]) }
  else
    result = result.map { |element| callback.call(element) }
  end

  result
end

original_list = [1, 2, 3, 4]
mapped_list = custom_mapping(original_list, ->(element) { element * 2 }, mutate: false)

puts mapped_list # Output: [2, 4, 6, 8]
-----------------------------------------------------------------------------------------------
### task 2 with dart 

bool customAny(List list, bool Function(int) callback) {
  for (int element in list) {
    if (callback(element)) {
      return true;
    }
  }
  return false;
}

bool customEvery(List list, bool Function(int) callback) {
  for (int element in list) {
    if (!callback(element)) {
      return false;
    }
  }
  return true;
}

bool customSome(List list, bool Function(int) callback, int threshold) {
  int count = 0;
  for (int element in list) {
    if (callback(element)) {
      count++;
      if (count >= threshold) {
        return true;
      }
    }
  }
  return false;
}

void main() {
  List originalList = [1, 2, 3, 4];

  bool anyResult = customAny(originalList, (element) => element == 2);
  bool everyResult = customEvery(originalList, (element) => element == 2);
  bool someResult = customSome(originalList, (element) => element == 2, 2);

  print("customAny: $anyResult"); // Output: true
  print("customEvery: $everyResult"); // Output: false
  print("customSome: $someResult"); // Output: true
}
### task 2 with Ruby

def custom_any(list, &callback)
  list.any?(&callback)
end

def custom_every(list, &callback)
  list.all?(&callback)
end

def custom_some(list, &callback)
  list.count(&callback) >= 2
end

original_list = [1, 2, 3, 4]

any_result = custom_any(original_list) { |element| element == 2 }
every_result = custom_every(original_list) { |element| element == 2 }
some_result = custom_some(original_list) { |element| element == 2 }

puts "customAny: #{any_result}" # Output: true
puts "customEvery: #{every_result}" # Output: false
puts "customSome: #{some_result}" # Output: true
---------------------------------------------------------------------------------------
### task 3 with Dart 

int customReducer(List<int> list, int Function(int, int) callback, int initialValue) {
  int result = initialValue;

  for (int element in list) {
    result = callback(result, element);
  }

  return result;
}

void main() {
  List<int> originalList = [1, 2, 3, 4];
  int output = customReducer(originalList, (acc, el) => el + acc, 15);

  print("Output: $output"); // Output: 25
}

### task 3 with Ruby
