import '../backend/models/integration.dart';

final integrations = [
  Integration(
    iconPath: "assets/icons/google-drive.svg",
    title: "Google Drive",
    description: "Sync forms with your Drive folders",
    onConnect: () => print("Connect Google Drive"),
  ),
  Integration(
    iconPath: "assets/icons/slack.svg",
    title: "Slack",
    description: "Send form results to Slack channels",
    onConnect: () => print("Connect Slack"),
  ),
  Integration(
    iconPath: "assets/icons/zapier.svg",
    title: "Zapier",
    description: "Automate workflows across 5000+ apps",
  ),
];
