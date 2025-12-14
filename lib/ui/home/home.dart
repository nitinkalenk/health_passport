import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_passport/providers/appointments_provider.dart';
import 'package:health_passport/providers/family_members_provider.dart';
import 'package:health_passport/ui/appointment/appointment_details.dart';
import 'package:health_passport/ui/family/family_member_details.dart';
import 'package:health_passport/providers/reports_provider.dart';

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
                  Expanded(child: _buildFamilySection(context, ref)),
                  const Divider(height: 1),
                  Expanded(child: _buildAppointmentsSection(context, ref)),
                  const Divider(height: 1),
                  Expanded(child: _buildReportsSection(context, ref)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySection(BuildContext context, WidgetRef ref) {
    final familyMembersAsyncValue = ref.watch(familyMembersProvider);

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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                UnconstrainedBox(
                  child: _buildCard(
                    context,
                    icon: Icons.add,
                    label: 'Add Family Member',
                    isAddButton: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                ...familyMembersAsyncValue.when(
                  data: (members) {
                    if (members.isEmpty) {
                      return [const Center(child: Text("No family members"))];
                    }
                    return members.expand(
                      (member) => [
                        UnconstrainedBox(
                          child: _buildCard(
                            context,
                            icon: Icons.person,
                            label: member.fullName,
                            isAddButton: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FamilyMemberDetailsScreen(member: member),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    );
                  },
                  loading: () => [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                  error: (err, stack) => [Center(child: Text('Error: $err'))],
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Create Appointment Button (Always Visible)
                UnconstrainedBox(
                  child: _buildCard(
                    context,
                    icon: Icons.add,
                    label: 'Create Appointment',
                    isAddButton: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),

                // Data / Loading / Error
                ...appointmentsAsyncValue.when(
                  data: (appointments) {
                    if (appointments.isEmpty) {
                      return [const Center(child: Text("No appointments"))];
                    }
                    return appointments.expand(
                      (appointment) => [
                        UnconstrainedBox(
                          child: _buildCard(
                            context,
                            icon: Icons.calendar_month,
                            label:
                                "${appointment.doctorName}\n${appointment.appointmentDate}",
                            isAddButton: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AppointmentDetailsScreen(
                                        appointment: appointment,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    );
                  },
                  loading: () => [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                  error: (err, stack) => [Center(child: Text('Error: $err'))],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection(BuildContext context, WidgetRef ref) {
    final reportsAsyncValue = ref.watch(reportsProvider);

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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                UnconstrainedBox(
                  child: _buildCard(
                    context,
                    icon: Icons.add,
                    label: 'Add Report',
                    isAddButton: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                ...reportsAsyncValue.when(
                  data: (reports) {
                    if (reports.isEmpty) {
                      return [const Center(child: Text("No reports"))];
                    }
                    return reports.expand(
                      (report) => [
                        UnconstrainedBox(
                          child: _buildCard(
                            context,
                            icon: report.type == 'bllod'
                                ? Icons.bloodtype
                                : Icons.description,
                            label: report.filename,
                            isAddButton: false,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    );
                  },
                  loading: () => [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                  error: (err, stack) => [Center(child: Text('Error: $err'))],
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
