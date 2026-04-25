import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/home/presentation/ConnectionBlock/connection_bloc.dart';

import '../../widgets/Connections/build_connect.dart';
import '../../widgets/Connections/build_request.dart';

class MyConnectionsPage extends StatefulWidget {
  const MyConnectionsPage({super.key});

  @override
  State<MyConnectionsPage> createState() => _MyConnectionsPageState();
}

class _MyConnectionsPageState extends State<MyConnectionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> connected = [
    {"name": "Marcus J.", "subtitle": "Engineering", "time": "Active now"},
    {"name": "Jessica Lee", "subtitle": "Biology", "time": "2h ago"},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ConnectionBloc>().add(ReadConnectionRequestEvent());
            Navigator.pop(context);
          },
        ),
        title: const Text("My Connections"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          dividerColor: Colors.transparent,
          unselectedLabelColor: text.bodyMedium?.color,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: colors.primary),
          ),
          tabs: [
            Tab(text: "Requests"),

            Tab(text: "Connected"),
          ],
        ),
      ),
      body: BlocBuilder<ConnectionBloc, ConnectionStates>(
        builder: (context, conState) {
          print("Building MyConnectionsPage with state: $conState");
          return Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<ConnectionBloc>().add(
                        LoadConnectionRequestsEvent(),
                      );
                      context.read<ConnectionBloc>().add(
                        LoadConnectionSuggestionsEvent(),
                      );
                      context.read<ConnectionBloc>().add(
                        LoadConnectionsEvent(),
                      );
                    },
                    child: buildRequests(theme, conState),
                  ),

                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<ConnectionBloc>().add(
                        LoadConnectionRequestsEvent(),
                      );
                      context.read<ConnectionBloc>().add(
                        LoadConnectionSuggestionsEvent(),
                      );
                      context.read<ConnectionBloc>().add(
                        LoadConnectionsEvent(),
                      );
                    },
                    child: buildConnected(theme, conState),
                  ),
                ],
              ),
              if (conState is ConnectionLoadingState) LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}
