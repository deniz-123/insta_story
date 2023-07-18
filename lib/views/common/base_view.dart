import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final T Function(BuildContext context) createModel;
  final Widget Function(
      BuildContext context, T model, Size size, EdgeInsets padding) builder;
  final bool static;
  const BaseView({
    Key? key,
    required this.createModel,
    required this.builder,
    this.static = false,
  }) : super(key: key);

  @override
  State<BaseView<T>> createState() => _BaseView<T>();
}

class _BaseView<T extends ChangeNotifier> extends State<BaseView<T>>
    with AutomaticKeepAliveClientMixin {
  late final T _model;
  late EdgeInsets _devicePadding;
  late Size _deviceSize;
  bool _initted = false;

  @override
  void didChangeDependencies() {
    if (!_initted) {
      _model = widget.createModel(context);
      _initted = true;
    }
    _devicePadding = MediaQuery.of(context).padding;
    _deviceSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: !widget.static
          ? ChangeNotifierProvider.value(
              value: _model,
              child: Consumer<T>(
                builder: (context, model, _) => widget.builder(
                  context,
                  model,
                  _deviceSize,
                  _devicePadding,
                ),
              ),
            )
          : widget.builder(
              context,
              _model,
              _deviceSize,
              _devicePadding,
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
