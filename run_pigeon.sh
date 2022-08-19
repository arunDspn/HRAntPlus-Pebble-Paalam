#flutter pub run pigeon \
#  --input pigeons/ant_api.dart \
#  --dart_out lib/ant_api.dart \
#  --java_out ./android/app/src/main/java/com/example/ant_pebble_paalam/AntServices.java \
#  --java_package "com.example.ant_pebble_paalam"

flutter pub run pigeon \
  --input pigeons/pebble_api.dart \
  --dart_out lib/pebble_api.dart \
  --java_out ./android/app/src/main/java/com/example/ant_pebble_paalam/PebbleServices.java \
  --java_package "com.example.ant_pebble_paalam"
