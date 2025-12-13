import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/providers/appointments_provider.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List of quote images
    final List<String> imgList = [
      'assets/images/quote1.png',
      'assets/images/quote2.png',
      'assets/images/quote3.png',
    ];

    return SingleChildScrollView(
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            kToolbarHeight, // Approximate available height
        child: Column(
          children: [
            // Carousel Section
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
              ),
              items: imgList
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            // Expanded Sections
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildFamilySection(context)),
                  const Divider(height: 1),
                  Expanded(child: _buildAppointmentsSection(context, ref)),
                  const Divider(height: 1),
                  Expanded(child: _buildReportsSection(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Family Members',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                _buildCard(
                  context,
                  icon: Icons.add,
                  label: 'Add Family Member',
                  isAddButton: true,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                _buildCard(
                  context,
                  icon: Icons.person,
                  label: 'John Doe',
                  isAddButton: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context, WidgetRef ref) {
    final appointmentsAsyncValue = ref.watch(appointmentsProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to top
              children: [
                // Create Button (Always visible)
                _buildCard(
                  context,
                  icon: Icons.add,
                  label: 'Create Appointment',
                  isAddButton: true,
                  onTap: () {},
                ),
                const SizedBox(width: 12),

                // List or Loading/Error
                Expanded(
                  child: appointmentsAsyncValue.when(
                    data: (appointments) {
                      if (appointments.isEmpty) {
                        return const Center(child: Text("No appointments"));
                      }
                      return ListView.separated(
                        itemCount: appointments.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            elevation: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              dense: true,
                              leading: const Icon(
                                Icons.calendar_month,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                appointment.doctorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${appointment.appointmentDate} • ${appointment.reason}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reports',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                _buildCard(
                  context,
                  icon: Icons.add,
                  label: 'Add Report',
                  isAddButton: true,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                _buildCard(
                  context,
                  icon: Icons.description,
                  label: 'Blood Work',
                  isAddButton: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isAddButton,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100, // Small square card
        height: 100, // Fixed height for alignment with list
        decoration: BoxDecoration(
          color: isAddButton
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isAddButton
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isAddButton ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
