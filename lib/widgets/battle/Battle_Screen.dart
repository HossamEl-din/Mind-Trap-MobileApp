import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad/cubits/battle_Cubit/Battle_State.dart';
import 'package:grad/cubits/battle_Cubit/battle_Cubit.dart';
import 'package:grad/widgets/battle/build_actionButton.dart';
import 'package:grad/widgets/battle/build_badge.dart';
import 'package:grad/widgets/battle/build_resultRow.dart';
import 'package:grad/widgets/battle/build_tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BattleScreen extends StatefulWidget {
  final int challengeId; 
  final int problemId;
  final bool isPractice; 

  const BattleScreen({
    super.key, 
    required this.challengeId, 
    required this.problemId,
    this.isPractice = false, // Default is false (Battle Mode)
  });
  

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  // اللغة الافتراضية
  String selectedLanguage = 'C++';
  
  final Map<String, int> languageMap = {
    'C++': 54,
    'Python': 71,
    'Java': 62,
    'C#': 51,
  };
  @override
  void initState() {
    super.initState();
    _loadSavedCode();
  }

  Future<void> _loadSavedCode() async {
    final prefs = await SharedPreferences.getInstance();
    // بنقرا الكود باستخدام الـ ID بتاع المسألة
    final savedCode = prefs.getString('saved_code_${widget.challengeId}');
    
    // لو لقينا كود محفوظ، بنحطه في مربع النص فوراً
    if (savedCode != null && savedCode.trim().isNotEmpty) {
      setState(() {
        codeController.text = savedCode;
      });
    }
  }
 final TextEditingController codeController = TextEditingController(
    // text: 'def twoSum(nums, target):\n    # Your code here\n    return []',
  );

 
  BattleLoaded? lastLoadedData;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
      // بننشئ الـ Cubit وبنبعتله الـ ID وبنقوله يـ fetch الداتا فوراً
      create: (context) => BattleCubit(challengeId: widget.challengeId, problemId: widget.problemId, isPractice: widget.isPractice)..fetchProblemDetails(),
     child: WillPopScope(
        onWillPop: () async {
          // 1. ننزل الكيبورد الأول
        
          
          // 3. نسمح للشاشة إنها تقفل بأمان
          return true; 
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF0F1522),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F1522),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text("Problem Details", style: TextStyle(color: Colors.white, fontSize: 18)),
            
            // 👈 ضفنا السهم المخصص هنا عشان يعمل نفس التأخير
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                
                  Navigator.pop(context);
           
              },
            ),
          ),
          // ... باقي الكود بتاع الـ body زي ما هو
          // استخدمنا BlocConsumer عشان نقدر نتصرف بناءً على الـ State
          body: BlocConsumer<BattleCubit, BattleState>(
            listener: (context, state) {
              
              
               if (state is SubmitSuccess) {
                showDialog(
    context: context, 
    barrierDismissible: false, 
    builder: (dialogContext) => AlertDialog( 
      backgroundColor: const Color(0xFF1A2235),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        // 👈 لو براكتس هنخلي الإطار أخضر، لو تحدي هنخليه دهبي
        side: BorderSide(color: widget.isPractice ? Colors.blueAccent : Colors.amber, width: 2)
      ),
      title: Row(
        children: [
          // 👈 تغيير الأيقونة
          Icon(
            widget.isPractice ? Icons.check_circle : Icons.emoji_events, 
            color: widget.isPractice ? Colors.greenAccent : Colors.amber, 
            size: 32
          ),
          const SizedBox(width: 10),
          // 👈 تغيير العنوان
          Text(
            widget.isPractice ? "Problem Solved!" : "Battle Won!", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
        ],
      ),
      content: Text(
        // 👈 تغيير الرسالة اللي بالعربي
        widget.isPractice 
         ? "Correct answer, awesome job! \nYour solution has been recorded successfully."
    : "Correct answer, brilliant! \nChallenge points have been added to your Leaderboard.",
        style: const TextStyle(color: Colors.greenAccent, fontSize: 16, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext), 
          child: const Text("Stay Here", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          // 👈 تغيير لون الزرار
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPractice ? Colors.blueAccent : Colors.amber, 
            foregroundColor: Colors.black
          ),
          onPressed: () {
            FocusScope.of(context).unfocus(); 
            Navigator.pop(dialogContext); 
            Navigator.pop(context); 
          },
          // 👈 تغيير كلمة الزرار
          child: Text(
            widget.isPractice ? "Go Back" : "Back to Arena", 
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
        )
      ],
    )
  );
              }
              
              
             else if (state is SubmitError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 4)),
                );
                
              }
           
              else if (state is HintLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Analyzing code for a hint... 🤖"), 
                    backgroundColor: Colors.indigo,
                    duration: Duration(seconds: 1),
                  ),
                );
              } 
              else if (state is HintError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.orange),
                );
              } 
              else if (state is HintLoaded) {
                // 👈 رسمنا BottomSheet شيك بيعرض الهينت بلون دهبي
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1A2235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                "Hint Level ${state.level}/3", // بيكتبله ده انهي هينت
                                style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.hint,
                            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A3150),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12)
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Got it!", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              // 👈 الحالات الجديدة بتاعة الذكاء الاصطناعي
              else if (state is AiHelpLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("AI is thinking about the optimal solution... 🧠"), 
                    backgroundColor: Color(0xFF4A148C),
                    duration: Duration(seconds: 2),
                  ),
                );
              } 
              else if (state is AiHelpError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                );
              } 
              // 👈 الحالة الجديدة بتاعة تقرير الفشل
            // 👈 حالة عرض تقرير الذكاء الاصطناعي (نجاح أو فشل)
              else if (state is SubmitAnalysisLoaded) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A2235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.75,
                      maxChildSize: 0.95,
                      builder: (_, controller) {
                        return SingleChildScrollView(
                          controller: controller,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. الهيدر (أيقونة والسكور) - تم حل مشكلة الـ Overflow هنا 👇
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.isPassed ? Icons.emoji_events : Icons.warning_amber_rounded, 
                                          color: state.isPassed ? Colors.amber : Colors.orangeAccent, 
                                          size: 28
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            state.isPassed ? "Awesome Job!" : "Submission Failed",
                                            style: TextStyle(color: state.isPassed ? Colors.amber : Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis, // 👈 دي اللي هتمنع الإيرور الأصفر
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: state.score >= 50 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: state.score >= 50 ? Colors.green : Colors.red),
                                    ),
                                    child: Text(
                                      "Score: ${state.score}%",
                                      style: TextStyle(color: state.score >= 50 ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(state.originalMessage, style: TextStyle(color: state.isPassed ? Colors.greenAccent : Colors.redAccent, fontSize: 14)),
                              const Divider(color: Color(0xFF2A3150), height: 30, thickness: 1),
                              
                              // 2. الملخص والتقييم
                              const Text("AI Feedback:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(state.brief, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                              const SizedBox(height: 16),
                              
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFF4A148C).withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.purple)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!state.isPassed) ...[
                                      // 👇 الكلمة اتغيرت هنا عشان تبقى منطقية
                                      const Text("Correctness Analysis:", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(state.correctnessReason, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                      const SizedBox(height: 12),
                                    ],
                                    const Text("Code Analysis Rubric:", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ...state.rubric.entries.map((e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(e.key, style: const TextStyle(color: Colors.white)),
                                          Text("${e.value}/10", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // 3. نقاط القوة والضعف (ديناميكية)
                              if (state.isPassed && state.strengths.isNotEmpty) ...[
                                const Text("Strengths:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8, runSpacing: 8,
                                  children: state.strengths.map((s) => Chip(
                                    label: Text(s.toString(), style: const TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green.withOpacity(0.2),
                                    side: const BorderSide(color: Colors.greenAccent),
                                  )).toList(),
                                ),
                                const SizedBox(height: 24),
                              ],
                              if (!state.isPassed && state.weaknesses.isNotEmpty) ...[
                                const Text("Weaknesses:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8, runSpacing: 8,
                                  children: state.weaknesses.map((w) => Chip(
                                    label: Text(w.toString(), style: const TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.orange.withOpacity(0.2),
                                    side: const BorderSide(color: Colors.orangeAccent),
                                  )).toList(),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // 4. زرار الإغلاق
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2A3150),
                                    padding: const EdgeInsets.symmetric(vertical: 12)
                                  ),
                                  onPressed: () {
                                    // 👇 كده هيقفل الـ BottomSheet بس ويسيبك في نفس الشاشة
                                    Navigator.pop(context); 
                                  },
                                  child: Text(
                                    state.isPassed ? "Got it!" : "Got it, let me fix it!", 
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                );
              }
              
              else if (state is ProblemExplainLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Breaking down the problem... 🔍"), 
                    backgroundColor: Colors.pinkAccent,
                    duration: Duration(seconds: 2),
                  ),
                );
              } 
              else if (state is ProblemExplainError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                );
              } 
              else if (state is ProblemExplainLoaded) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF1A2235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.65,
                      maxChildSize: 0.9,
                      builder: (_, controller) {
                        return SingleChildScrollView(
                          controller: controller,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_stories, color: Colors.pinkAccent, size: 28),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Problem Breakdown",
                                    style: TextStyle(color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              // 1. الملخص
                              const Text("Overview:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(state.explanation, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                              const SizedBox(height: 20),
                              
                              // 2. الخوارزمية (الخطوات)
                              const Text("Algorithm Steps:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0F18),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(state.algorithm, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                              ),
                              const SizedBox(height: 20),
                              
                              // 3. كروت الـ Complexity
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: const Color(0xFF0A0F18), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2A3150))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Row(children: [Icon(Icons.timer, color: Colors.white54, size: 16), SizedBox(width: 6), Text("Time", style: TextStyle(color: Colors.white54))]),
                                          const SizedBox(height: 8),
                                          Text(state.timeComplexity, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: const Color(0xFF0A0F18), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF2A3150))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Row(children: [Icon(Icons.memory, color: Colors.white54, size: 16), SizedBox(width: 6), Text("Space", style: TextStyle(color: Colors.white54))]),
                                          const SizedBox(height: 8),
                                          Text(state.spaceComplexity, style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // زرار القفل
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent.withOpacity(0.15),
                                    foregroundColor: Colors.pinkAccent,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.pinkAccent),
                                    padding: const EdgeInsets.symmetric(vertical: 12)
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Understood!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                );
              }
              else if (state is AiHelpLoaded) {
               
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, 
                  backgroundColor: const Color(0xFF1A2235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.6, 
                      maxChildSize: 0.9,     
                      builder: (_, controller) {
                        return SingleChildScrollView(
                          controller: controller,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.smart_toy, color: Colors.purpleAccent, size: 28),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Optimal AI Solution",
                                    style: TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              
                              const Text("Explanation:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(state.explanation, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
                              const SizedBox(height: 20),
                              
                              
                              const Text("Implementation:", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0F18),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF2A3150)),
                                ),
                                child: Text(
                                  state.llmCode,
                                  style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'monospace', fontSize: 14, height: 1.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A148C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12)
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Got it!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                );
              }
             else if (state is RunCodeSuccess) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1A2235),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // العنوان والحالة (ناجح ولا سقط)
                          Row(
                            children: [
                              Icon(
                                state.passed ? Icons.check_circle : Icons.cancel,
                                color: state.passed ? Colors.greenAccent : Colors.redAccent,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                state.passed ? "Accepted" : "Wrong Answer",
                                style: TextStyle(
                                  color: state.passed ? Colors.greenAccent : Colors.redAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
        
                          // تفاصيل المدخلات والمخرجات
                          buildResultRow("Input:", state.input),
                          const SizedBox(height: 12),
                          buildResultRow("Expected Output:", state.expectedOutput),
                          const SizedBox(height: 12),
                          buildResultRow(
                            "Your Output:", 
                            state.actualOutput, 
                            isError: !state.passed && state.actualOutput.contains("Error")
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              }
              else if (state is RunCodeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.orange),
                );
              }
            },
            builder: (context, state) {
              if (state is BattleLoaded) {
                lastLoadedData = state;
              }
              if (state is BattleLoading || state is CodeRunning || state is SubmitLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.cyanAccent),
                      const SizedBox(height: 16),
                      Text(
                        state is SubmitLoading ? "Submitting Solution..." : "Loading...", 
                        style: const TextStyle(color: Colors.white)
                      ),
                    ],
                  ),
                );
              }
        
              if (state is BattleError) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }
              
              // 👈 حلينا مشكلة الشاشة البيضاء هنا
             if (lastLoadedData == null) {
                return const SizedBox(); 
              }
              
              // 4. نقرأ الداتا من الذاكرة المحفوظة بدل ما نعتمد على الـ state الحالية بس
              final data = lastLoadedData!;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. التاجز (Tags)
                    if (data.tags.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: data.tags.map((tag) => buildTag(tag)).toList(),
                      ),
                    if (data.tags.isNotEmpty) const SizedBox(height: 16),
        
                    // 2. مستوى الصعوبة والمصدر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            buildBadge(
                              data.difficulty, 
                              data.difficulty == "Easy" ? Colors.greenAccent : (data.difficulty == "Medium" ? Colors.orange : Colors.redAccent)
                            ),
                            const SizedBox(width: 10),
                            buildBadge(data.source, Colors.amber),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
        
                    // 3. اسم ووصف المسألة
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2235),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A3150)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title.toUpperCase(),
                            style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data.statement,
                            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          
                          // لو فيه Input Format راجع من السيرفر نعرضه
                          if (data.inputFormat.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A0F18), 
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 14, height: 1.5, fontFamily: 'monospace'),
                                  children: [
                                    const TextSpan(text: "Input Format:\n", style: TextStyle(color: Colors.cyanAccent)),
                                    TextSpan(text: "${data.inputFormat}\n\n", style: const TextStyle(color: Colors.white)),
                                    const TextSpan(text: "Output Format:\n", style: TextStyle(color: Colors.pinkAccent)),
                                    TextSpan(text: data.outputFormat, style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // 4. مكان كتابة الكود
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2235),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A3150)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "YOUR CODE",
                                style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                              ),
                              // 👈 الدروب داون الجديد
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0F18),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF2A3150)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedLanguage,
                                    dropdownColor: const Color(0xFF1A2235),
                                    icon: const Icon(Icons.code, color: Colors.cyanAccent, size: 18),
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    items: languageMap.keys.map((String lang) {
                                      return DropdownMenuItem<String>(
                                        value: lang,
                                        child: Text(lang),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedLanguage = newValue;
                                          // 💡 اختياري: نغير الكود المبدئي حسب اللغة
                                          if (newValue == 'Python') {
                                            codeController.text = 'def solve():\n    # Your code here\n    pass';
                                          } else if (newValue == 'C++') {
                                            codeController.text = '#include <iostream>\nusing namespace std;\n\nint main() {\n    // Your code here\n    return 0;\n}';
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0F18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: codeController,
                              maxLines: null, 
                              minLines: 8,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace', 
                                fontSize: 14,
                                height: 1.5,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
        
                   
                   buildActionButton(
                      text: "Get Hint",
                      icon: Icons.lightbulb,
                      bgColor: const Color(0xFF1A2235),
                      textColor: Colors.cyanAccent,
                      borderColor: const Color(0xFF2A3150),
                      onPressed: () {
                        if (lastLoadedData != null) {
                          context.read<BattleCubit>().getHint(
                            lastLoadedData!.statement, 
                            codeController.text
                          );
                        }
                      }
                    ),
                    const SizedBox(height: 12),
                   buildActionButton(
                      text: "AI Help",
                      icon: Icons.smart_toy,
                      bgColor: const Color(0xFF4A148C), 
                      textColor: Colors.white,
                      onPressed: () {
                       
                        if (lastLoadedData != null) {
                          context.read<BattleCubit>().getAiHelp(
                            lastLoadedData!.statement, 
                            codeController.text
                          );
                        }
                      }
                    ),
                    const SizedBox(height: 12),
                    buildActionButton(
                      text: "Explain Problem",
                      icon: Icons.auto_stories, 
                      bgColor:  Color(0xFF1A2235), 
                      textColor: Colors.pinkAccent,
                      borderColor: const Color(0xFF2A3150),
                      onPressed: () {
                        if (lastLoadedData != null) {
                          context.read<BattleCubit>().explainProblem(lastLoadedData!.statement);
                        }
                      }
                    ),
                    const SizedBox(height: 12),
                    buildActionButton(
                      text: "Run Code",
                      bgColor: const Color(0xFF007BFF), 
                      textColor: Colors.white,
                      isBold: true,
                     onPressed: () {
                        final userCode = codeController.text;
                        if (userCode.trim().isNotEmpty) {
                          // 👈 غيرنا دي لـ runCode
                          context.read<BattleCubit>().runCode(userCode, languageMap[selectedLanguage]!); 
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please write some code first!"), backgroundColor: Colors.orange),
                          );    
                        }
                      }
                    ),
                    const SizedBox(height: 12),
                    buildActionButton(
                      text: "Submit Solution",
                      bgColor: const Color(0xFF0F1522),
                      textColor: Colors.greenAccent,
                      borderColor: Colors.greenAccent.withOpacity(0.5),
                      isBold: true,
                      onPressed: () {
                        final userCode = codeController.text;
                        if (userCode.trim().isNotEmpty && lastLoadedData != null) {
                    
                          context.read<BattleCubit>().submitSolution(
                            userCode, 
                            languageMap[selectedLanguage]!,
                            problemStatement: lastLoadedData!.statement
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please write some code first!"), backgroundColor: Colors.orange),
                          );    
                        }
                      }
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}