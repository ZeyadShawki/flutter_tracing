import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracing/src/tracing/phonetics_paint_widget/phonetics_painter.dart';
import 'package:tracing/tracing.dart';

import '../manager/tracing_cubit.dart';

class TracingWordGame extends StatefulWidget {
  const TracingWordGame({super.key, required this.words, required this.tracingListener,  this.loadingIndictor=const CircularProgressIndicator(), });
  final List<String> words;
  final  Future<void> Function(BuildContext, TracingState) tracingListener;
  final Widget loadingIndictor;
  @override
  State<StatefulWidget> createState() => _TracingWordGameState();
}

class _TracingWordGameState extends State<TracingWordGame> {
  late TracingCubit tracingCubit;

  @override
  void initState() {
    super.initState();
    tracingCubit = TracingCubit(
      stateOfTracing:StateOfTracing.traceWords ,
      traceShapeModel: widget.words.map((e)=>TraceShapeModel(shapes: [e])).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Adjust bottom padding based on platform and navigation bar presence
    return BlocProvider(
        create: (context) => tracingCubit,
        child: BlocConsumer<TracingCubit, TracingState>(
            listener:(context, stateOfGame)async {
           await   widget.tracingListener(context,stateOfGame);
                 if (stateOfGame.drawingStates == DrawingStates.finishedCurrentScreen) {
     
                if (context.mounted) {
                  
                  context.read<TracingCubit>().updateIndex();
                
              
      
                }}
            }, builder: (context, state) {
          if (state.drawingStates == DrawingStates.loading ||
              state.drawingStates == DrawingStates.initial) {
            return widget. loadingIndictor;
          }
  

        return Container(
          
          child: FittedBox(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // margin: REdgeInsets.only(
                    //     right: state.isArabic ? 80 : 0,
                    //     left: state.isArabic ? 80 : 0),
                    child: FittedBox(
                      child: Container(

                        // margin: REdgeInsets.only(left: 0),
                        // color: Colors.amber,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.s,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(
                              state.letterPathsModels.length,
                              (index) {
                            
                                return Container(
                                  height: state
                                      .letterPathsModels[index].viewSize.width,
                                  width: state
                                      .letterPathsModels[index].viewSize.height,
                                  margin: state.letterPathsModels[index].isSpace
                                      ? EdgeInsets.only(right: 150)
                                      : EdgeInsets.zero,

                                  // padding: REdgeInsets.only(
                                  //   bottom:context.isTablet()? 0:100.h
                                  // ),
                                  // color: Colors.green,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: GestureDetector(
                                      onPanStart: (details) {
                                    
                                        if (index == state.activeIndex) {
                                          tracingCubit.handlePanStart(
                                              details.localPosition);
                                        }
                                      },
                                      onPanUpdate: (details) {

                                        if (index == state.activeIndex) {

                                          tracingCubit.handlePanUpdate(
                                              details.localPosition);
                                        }
                                      },
                                      onPanEnd: (details) {},
                                      child: Stack(
                                        // fit: StackFit.loose,
                                        clipBehavior: Clip.none,
                                        // alignment: Alignment.b,
                                        children: [
                                          CustomPaint(
                                            // isComplex: true,
                                            size: tracingCubit.viewSize,

                                            painter: PhoneticsPainter(
                                              strokeIndex: state
                                                  .letterPathsModels[index]
                                                  .strokeIndex,
                                              indexPath: state
                                                  .letterPathsModels[index]
                                                  .letterIndex,
                                              dottedPath: state
                                                  .letterPathsModels[index]
                                                  .dottedIndex,
                                              letterColor: state
                                                  .letterPathsModels[index]
                                                  .outerPaintColor,
                                              letterImage: state
                                                  .letterPathsModels[index]
                                                  .letterImage!,
                                              paths: state
                                                  .letterPathsModels[index]
                                                  .paths,
                                              currentDrawingPath: state
                                                  .letterPathsModels[index]
                                                  .currentDrawingPath,
                                              pathPoints: state
                                                  .letterPathsModels[index]
                                                  .allStrokePoints
                                                  .expand((p) => p)
                                                  .toList(),
                                              strokeColor: state
                                                  .letterPathsModels[index]
                                                  .innerPaintColor,
                                              viewSize: state
                                                  .letterPathsModels[index]
                                                  .viewSize,
                                              strokePoints: state
                                                      .letterPathsModels[index]
                                                      .allStrokePoints[
                                                  state.letterPathsModels[index]
                                                      .currentStroke],
                                              strokeWidth: state
                                                  .letterPathsModels[index]
                                                  .strokeWidth,
                                              dottedColor: state
                                                  .letterPathsModels[index]
                                                  .dottedColor,
                                              indexColor: state
                                                  .letterPathsModels[index]
                                                  .indexColor,
                                              indexPathPaintStyle: state
                                                  .letterPathsModels[index]
                                                  .indexPathPaintStyle,
                                              dottedPathPaintStyle: state
                                                  .letterPathsModels[index]
                                                  .dottedPathPaintStyle,
                                            ),
                                          ),
                                          if (state.activeIndex == index)
                                            Positioned(
                                              top: state
                                                  .letterPathsModels[
                                                      state.activeIndex]
                                                  .anchorPos!
                                                  .dy,
                                              left: state
                                                  .letterPathsModels[
                                                      state.activeIndex]
                                                  .anchorPos!
                                                  .dx,
                                              child: Image.asset(
                                          'packages/tracing/assets/images/position_2_finger.png',

                                                height: 50,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
