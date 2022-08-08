import 'package:ant_pebble_paalam/main.dart';
import 'package:ant_pebble_paalam/search_devices/connect_ant_device_cubit/connect_ant_device_cubit.dart';
import 'package:ant_pebble_paalam/search_devices/search_result_cubit/search_result_cubit.dart';
import 'package:ant_pebble_paalam/widgets/fullscreen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchDevicesModal extends StatelessWidget {
  const SearchDevicesModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kPrimaryColorBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const Text('Searching Devices'),
                  const CircularProgressIndicator(
                    strokeWidth: 1,
                    value: 1,
                  )
                ],
              ),
            ),
            const Divider(),
            MultiBlocListener(
              listeners: [
                BlocListener<SearchResultCubit, SearchResultState>(
                  listener: (context, state) {
                    if (state is SearchResultDone) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                BlocListener<ConnectAntDeviceCubit, ConnectAntDeviceState>(
                  listener: (context, state) {
                    if (state is ConnectAntDeviceLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const FullScreenLoader();
                        },
                      );
                    } else if (state is ConnectAntDeviceSuccess) {
                      // Update ant device status widget
                      // This removes fullscreen loader
                      Navigator.of(context).pop();
                      // Removes result modal
                      context.read<SearchResultCubit>().closeSearchResult();
                    } else if (state is ConnectAntDeviceFailed) {
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
              child: BlocBuilder<SearchResultCubit, SearchResultState>(
                builder: (context, state) {
                  if (state is SearchResultLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchResultLoaded) {
                    final data = state.devices;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            leading: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.devices),
                            ),
                            title: Text(data[index]!.deviceName),
                            subtitle:
                                Text(data[index]!.deviceNumber.toString()),
                            onTap: () {
                              context
                                  .read<ConnectAntDeviceCubit>()
                                  .connectToDevice(data[index]!.deviceNumber);
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is SearchResultFailed) {
                    return const Text('data failed');
                  } else {}
                  return const Text('Not invoked');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
