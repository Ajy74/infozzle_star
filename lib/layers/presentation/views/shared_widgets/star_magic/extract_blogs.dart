import 'package:html/parser.dart' as htmlParser;

String extractPlainText(String htmlText) {
  String textToRemove1 =
      "Jerry hosts these free live Mystery School Teachings every month, sometimes twice, covering different topics and subjects, giving you the chance to learn new skills and and take new tools into your spiritual arsenal that you can use every day to keep unlocking more of who you are, more of your Divine Potential.";

  String textToRemove2 = "Are you ready?";
  String textToRemove3 = "Expect Transformation.";
  String textToRemove4 = "See You on the Inside Beautiful Souls";

  String plainText = htmlText.replaceAll(textToRemove1, '');
  plainText = plainText.replaceAll(textToRemove2, '');
  plainText = plainText.replaceAll(textToRemove3, '');
  plainText = plainText.replaceAll(textToRemove4, '');
  plainText = plainText.replaceAll(RegExp(r'<[^>]*>'), '');
  plainText = plainText.replaceAll(RegExp(r'&[^;]*;'), '');

  RegExp audioRegex = RegExp(r'\[audio[^\]]*?\].*?\[/audio\]');
  plainText = plainText.replaceAll(audioRegex, '');

  plainText = plainText.trim();

  return plainText;
}

String extractAudioLink(String htmlText) {
  RegExp audioRegex = RegExp(r'\[audio mp3="([^"]+)"\]');
  RegExpMatch? match = audioRegex.firstMatch(htmlText);
  if (match != null && match.groupCount >= 1) {
    return match.group(1)!;
  }
  return '';
}

String parseHtmlToRecipeModel(String htmlString) {
  var document = htmlParser.parse(htmlString);
  var shortMessage = document.querySelector('p.p2')?.text.trim() ?? '';

  return shortMessage;
}

String extractYouTubeLink(String htmlContent) {
  RegExp exp = RegExp(r'src="(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/embed\/|youtu\.be\/)([\w\-]+)"');

  Match? match = exp.firstMatch(htmlContent);
  if (match != null && match.groupCount >= 1) {
    String videoId = match.group(1)!;
    String youtubeLink = 'https://www.youtube.com/watch?v=$videoId';
    return youtubeLink;
  }

  return '';
}
