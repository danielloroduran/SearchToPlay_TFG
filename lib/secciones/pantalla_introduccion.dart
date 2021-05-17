import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class IntroduccionPage extends StatefulWidget{

  _IntroduccionPageState createState() => new _IntroduccionPageState();

}

class _IntroduccionPageState extends State<IntroduccionPage>{
  final introKey = GlobalKey<_IntroduccionPageState>();


  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){

    var pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).backgroundColor,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).backgroundColor,
      globalHeader: Align(
        alignment: Alignment.topCenter,
      ),
      pages: [
        PageViewModel(
          title: "Te encuentras en SearchToPlay",
          body: "",
          image: Container(
            width: 300,
            height: 300,
            child: Image(
              image: AssetImage(Theme.of(context).brightness == Brightness.dark ? 'assets/launch_image_dark.png' : 'assets/launch_image_light.png'),
            ),
          ),
          decoration: pageDecoration
        ),
        PageViewModel(
          title: "Infórmate",
          body: "No te pierdas nada de tu juego favorito, y descubre cuál será el próximo",
          image: Container(
            child: Lottie.asset('assets/lottie/game_controller.json', repeat: true, reverse: true),
          ),
          decoration: pageDecoration
        ),
        PageViewModel(
          title: "Busca y encuentra",
          body: "¿Dudas con datos de algún juego? Aquí lo resolverás",
          image: Container(            
            child: Theme.of(context).brightness == Brightness.dark ? ColorFiltered(
              child: Lottie.asset('assets/lottie/search.json', repeat: true, reverse: true),
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
            ) : Lottie.asset('assets/lottie/search.json', repeat: true, reverse: true),
          ),
          decoration: pageDecoration
        ),
        PageViewModel(
          title: "Guarda y evalúa",
          body: "Da me gusta, mantén una lista de tus juegos completados y evalúalos",
          image: Container(
            child: Lottie.asset('assets/lottie/like.json', repeat: true, reverse: true),
          ),
          decoration: pageDecoration
        ),
        PageViewModel(
          title: "Logros",
          body: "Consigue logros, ¡y mantente en lo alto en El Top Jugones!",
          image: Container(
            child: Lottie.asset('assets/lottie/logro.json', repeat: true, reverse: true),
          ),
          decoration: pageDecoration
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Saltar'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('¡Listo!', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}