import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_haven_admin/const.dart';
import 'package:tech_haven_admin/core/common/controller/help_request_provider.dart';
import 'package:tech_haven_admin/core/common/widgets/header_widget.dart';
import 'package:tech_haven_admin/core/model/help_center_request_model.dart';
import 'package:tech_haven_admin/core/model/help_request_model.dart';
import 'package:tech_haven_admin/features/categories/widgets/cutsom_button.dart';
import 'package:tech_haven_admin/features/categories/widgets/title_and_subtitle_row.dart';
import 'package:tech_haven_admin/features/main/responsive/responsive.dart';
import 'package:tech_haven_admin/utils/sum.dart';

class ManageHelpRequestsPage extends StatelessWidget {
  const ManageHelpRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 18,
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 5 : 18),
              const Header(),
              height(context),
              const TitleAndSubTitleRow(
                title: 'Pending to Answer.',
                subTitle: "Here You can Help The User about their queries",
              ),
              Consumer<HelpRequestProvider>(
                builder: (context, helpRequestProvider, child) {
                  return StreamBuilder<List<HelpCenterRequestModel>>(
                    stream: helpRequestProvider.getHelpCenterRequests(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No help center requests found.'));
                      }

                      final helpCenterRequests = snapshot.data!;

                      return Column(
                        children: helpCenterRequests.map((request) {
                          return _buildHelpRequestAccordion(
                              context, request, helpRequestProvider, false);
                        }).toList(),
                      );
                    },
                  );
                },
              ),
              height(context),
              const TitleAndSubTitleRow(
                title: 'Request Answered',
                subTitle: "Here You can see the answered requests",
              ),
              Consumer<HelpRequestProvider>(
                builder: (context, helpRequestProvider, child) {
                  return StreamBuilder<List<HelpCenterRequestModel>>(
                    stream: helpRequestProvider.getHelpCenterRequests(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No help center requests found.'));
                      }

                      final helpCenterRequests = snapshot.data!;

                      return Column(
                        children: helpCenterRequests.map((request) {
                          return _buildHelpRequestAccordion(
                              context, request, helpRequestProvider, true);
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpRequestAccordion(
      BuildContext context,
      HelpCenterRequestModel request,
      HelpRequestProvider helpRequestProvider,
      bool answered) {
    return Accordion(
      maxOpenSections: 1,
      disableScrolling: true,
      headerBackgroundColorOpened: Colors.black54,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.light,
      sectionClosingHapticFeedback: SectionHapticFeedback.heavy,
      children: [
        AccordionSection(
          isOpen: false,
          headerBackgroundColor: cardBackgroundColor,
          header: Text(
            request.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          contentBackgroundColor: const Color(0xFF2F353E),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Name: ${request.userName}'),
              Text('Last Request Date: ${formatDateTime(request.dateTime)}'),
              const SizedBox(height: 10),
              // Fetch and display HelpRequestModel list for this HelpCenterRequestModel
              _buildHelpRequestList(
                  context, request.userID, helpRequestProvider, answered),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpRequestList(BuildContext context, String userID,
      HelpRequestProvider helpRequestProvider, bool answered) {
    return StreamBuilder<List<HelpRequestModel>>(
      stream: helpRequestProvider.getHelpRequests(userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No requests found.'));
        }

        final helpRequests = snapshot.data!;
        final nonAnsweredHelpRequests = helpRequests
            .where((element) =>
                answered ? element.answer != null : element.answer == null)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nonAnsweredHelpRequests.map((helpRequest) {
            return ListTile(
              title: Text(helpRequest.subject),
              subtitle: Text(formatDateTime(helpRequest.dateTime)),
              trailing: SizedBox(
                width: 100,
                child: CustomButton(
                  isLoading: false,
                  onPressedButton: () {
                    _showAnswerDialog(
                        context, helpRequest, helpRequestProvider, answered);
                  },
                  buttonText: answered ? 'Show Details' : 'Answer',
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showAnswerDialog(BuildContext context, HelpRequestModel helpRequest,
      HelpRequestProvider helpRequestProvider, bool answered) {
    TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying Date Time
                  Text(
                    'Date Time: ${formatDateTime(helpRequest.dateTime)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8), // Adding space between elements

                  // Displaying User Email
                  Text(
                    'User Email: ${helpRequest.email}',
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12), // Adding space between elements

                  // Displaying Subject
                  Text(
                    helpRequest.subject,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12), // Adding space between elements

                  // Displaying Email Body
                  Text(
                    helpRequest.body,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20), // Adding space between elements
                  const Text(
                    'Answer',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  // Text Field for Reply
                  (!answered)
                      ? TextField(
                          controller: replyController,
                          decoration: const InputDecoration(
                            labelText: 'Reply',
                            border: OutlineInputBorder(),
                          ),
                          minLines: 3, // Minimum of 3 lines visible
                          maxLines:
                              10, // Maximum of 10 lines visible before scrolling
                          keyboardType:
                              TextInputType.multiline, // Allows multiline input
                          // Optional: If you want to restrict the number of characters per line,
                          // you can use maxLength and maxLengthEnforced properties.
                        )
                      : Text(
                          helpRequest.answer ?? '',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),

                  const SizedBox(height: 16), // Adding space between elements

                  // Submit Button
                  CustomButton(
                    isLoading: false,
                    onPressedButton: () async {
                      if (answered) {
                        Navigator.of(context).pop(); // Close dialog
                      } else {
                        String replyText = replyController.text.trim();
                        if (replyText.isNotEmpty) {
                          // Handle sending reply (e.g., through a service or provider)
                          // Here you can add logic to send the reply
                          await helpRequestProvider.answerTheRequest(
                              helpRequestModel: helpRequest, answer: replyText);
                          replyController
                              .clear(); // Clear reply field after submission
                          Navigator.of(context).pop(); // Close dialog
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                      'Fill the box to Reply to the Request')));
                        }
                      }
                      // Handle reply submission
                    },
                    buttonText: answered ? 'Close' : 'Submit',
                  ),
                ],
              )),
        );
      },
    );
  }
}
