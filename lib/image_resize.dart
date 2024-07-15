import 'dart:typed_data';
import 'package:image/image.dart' as img;

Uint8List createThumbnail(Uint8List passedImage, int largestSide) {
  // Decode the image from the byte array
  img.Image? startImage = img.decodeImage(passedImage);
  if (startImage == null) {
    throw Exception('Unable to decode image');
  }

  // Calculate the new dimensions while maintaining the aspect ratio
  int newHeight, newWidth;
  if (startImage.height > startImage.width) {
    newHeight = largestSide;
    newWidth = (largestSide * startImage.width / startImage.height).round();
  } else {
    newWidth = largestSide;
    newHeight = (largestSide * startImage.height / startImage.width).round();
  }

  // Resize the image
  img.Image newImage =
      img.copyResize(startImage, width: newWidth, height: newHeight);

  // Encode the resized image to JPEG format
  Uint8List returnedThumbnail = Uint8List.fromList(img.encodeJpg(newImage));

  // Return the resized image as a byte array
  return returnedThumbnail;
}

// void main() {
//   // Example usage:
//   // Assume `imageBytes` is the byte array of the original image
//   Uint8List imageBytes = ...;
//   int largestSide = 100; // Set the desired largest side for the thumbnail

//   Uint8List thumbnailBytes = createThumbnail(imageBytes, largestSide);

//   // Now `thumbnailBytes` contains the resized image data
// }