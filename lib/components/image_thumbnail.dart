import 'package:flutter/material.dart';

typedef ImageTapCallBack = void Function(int index);
typedef ImageLoadingCallBack = Widget Function(
    BuildContext, Widget, ImageChunkEvent?);
typedef ImageErrorCallBack = Widget Function(BuildContext, Object, StackTrace?);

typedef OnTapCallBack = void Function();

class ImageThumbnail extends StatelessWidget {
  final String _url;

  final double? _width;
  final double? _height;
  final ImageLoadingCallBack? _imageLoadingCallBack;
  final ImageErrorCallBack? _imageErrorCallBack;
  final OnTapCallBack? _onTapCallBack;

  const ImageThumbnail(this._url,
      {Key? key,
      double? width,
      double? height,
      ImageLoadingCallBack? imageLoadingCallBack,
      ImageErrorCallBack? imageErrorCallBack,
      OnTapCallBack? onTapCallBack})
      : _width = width,
        _height = height,
        _imageLoadingCallBack = imageLoadingCallBack,
        _imageErrorCallBack = imageErrorCallBack,
        _onTapCallBack = onTapCallBack,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTapCallBack?.call();
      },
      child: Image.network(
        _url,
        width: _width,
        height: _height,
        loadingBuilder: _imageLoadingCallBack ??
            (context, child, event) {
              if (event == null) {
                return child;
              }
              return const Center(child: CircularProgressIndicator());
            },
      ),
    );
  }
}
