import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';

// --- MODEL ---
class ExerciseItem {
  final String title;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final List<String> steps;

  ExerciseItem({
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrl,
    required this.steps,
  });
}

class ExercisesTab extends ConsumerStatefulWidget {
  const ExercisesTab({super.key});

  @override
  ConsumerState<ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends ConsumerState<ExercisesTab> {
  String _selectedCategory = "Tümü";
  String _selectedEquipment = "Tümü";

  final List<String> _categories = ["Tümü", "Göğüs", "Sırt", "Bacak", "Omuz", "Kol", "Karın", "Cardio"];
  final List<String> _equipments = ["Tümü", "Barbell", "Dumbbell", "Makine", "Vücut Ağırlığı", "Kablo"];

  // --- GENİŞLETİLMİŞ EGZERSİZ KÜTÜPHANESİ ---
  final List<ExerciseItem> _allExercises = [
    // --- GÖĞÜS ---
    ExerciseItem(
      title: "Bench Press",
      description: "Göğüs kasları için temel kuvvet hareketi.",
      tags: ["Göğüs", "Barbell"],
      imageUrl: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&q=80&w=2070",
      steps: ["Sırt üstü sehpaya uzanın.", "Barı omuz genişliğinden biraz geniş tutun.", "Barı göğüs ucunuza kontrollü indirin.", "Nefes vererek yukarı itin."],
    ),
    ExerciseItem(
      title: "Incline Dumbbell Press",
      description: "Üst göğüs kaslarını hedefleyen itiş hareketi.",
      tags: ["Göğüs", "Dumbbell"],
      imageUrl: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&q=80&w=2070",
      steps: ["Sehpayı 30-45 derece eğime getirin.", "Dumbbell'ları omuz hizasında tutun.", "Yukarı doğru itin ve tepe noktada göğsü sıkın.", "Kontrollü şekilde indirin."],
    ),
    ExerciseItem(
      title: "Cable Crossover",
      description: "Göğüs kaslarını izole eden sıkıştırma hareketi.",
      tags: ["Göğüs", "Kablo"],
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2070",
      steps: ["Kablo makinesinin ortasında durun.", "Kolları hafif bükülü tutarak öne doğru birleştirin.", "Göğüs kaslarını iyice sıkın.", "Yavaşça başlangıç konumuna dönün."],
    ),

    // --- SIRT ---
    ExerciseItem(
      title: "Deadlift",
      description: "Tüm vücut kuvveti ve arka zincir gelişimi.",
      tags: ["Sırt", "Barbell"],
      imageUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&q=80&w=2070",
      steps: ["Barın önünde durun, ayaklar kalça genişliğinde.", "Kalçayı geriye iterek barı kavrayın.", "Sırt düz, göğüs yukarıda barı kaldırın.", "Tepe noktada kalçayı sıkın."],
    ),
    ExerciseItem(
      title: "Lat Pulldown",
      description: "Sırt genişliği ve kanat kasları için.",
      tags: ["Sırt", "Makine"],
      imageUrl: "https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&q=80&w=2074",
      steps: ["Barı geniş tutun.", "Barı göğsünüzün üst kısmına çekin.", "Dirsekleri geriye ve aşağıya odaklayın.", "Yavaşça yukarı bırakın."],
    ),
    ExerciseItem(
      title: "Seated Cable Row",
      description: "Sırt kalınlığı ve orta sırt detayları için.",
      tags: ["Sırt", "Kablo"],
      imageUrl: "https://images.unsplash.com/photo-1603287681836-e60567a2d119?auto=format&fit=crop&q=80&w=2070",
      steps: ["Sırtınız dik bir şekilde oturun.", "Kulpu karnınıza doğru çekin.", "Kürek kemiklerini birbirine yaklaştırın.", "Kolları öne doğru uzatın."],
    ),

    // --- BACAK ---
    ExerciseItem(
      title: "Squat",
      description: "Bacak ve kalça gelişimi için kral hareket.",
      tags: ["Bacak", "Barbell"],
      imageUrl: "https://images.unsplash.com/photo-1574680096145-d05b474e2155?auto=format&fit=crop&q=80&w=2069",
      steps: ["Barı sırtınıza yerleştirin.", "Kalçayı geriye iterek çömelin.", "Dizler ayak ucunu geçmemeli.", "Topuklardan güç alarak kalkın."],
    ),
    ExerciseItem(
      title: "Leg Press",
      description: "Yüksek ağırlıkla bacak kaslarını çalıştırma.",
      tags: ["Bacak", "Makine"],
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2070",
      steps: ["Makineye oturun ve ayakları platforma yerleştirin.", "Kilidi açıp ağırlığı kontrollü indirin.", "Dizleri kilitlemeden ağırlığı itin."],
    ),
    ExerciseItem(
      title: "Lunges",
      description: "Tek bacak kuvveti ve denge.",
      tags: ["Bacak", "Dumbbell"],
      imageUrl: "https://images.unsplash.com/photo-1579758629938-03607ccdbaba?auto=format&fit=crop&q=80&w=2070",
      steps: ["Bir adım öne atın.", "Arka diz yere değecek kadar alçalın.", "Ön bacaktan güç alarak başlangıca dönün.", "Diğer bacakla tekrarlayın."],
    ),
    ExerciseItem(
      title: "Leg Extension",
      description: "Ön bacak (Quadriceps) izolasyonu.",
      tags: ["Bacak", "Makine"],
      imageUrl: "https://plus.unsplash.com/premium_photo-1672363353887-d5a9d1a3c841?auto=format&fit=crop&q=80&w=2070",
      steps: ["Makineye oturun.", "Bacaklarınızı dümdüz olana kadar kaldırın.", "Tepe noktada ön bacakları sıkın.", "Yavaşça indirin."],
    ),

    // --- OMUZ ---
    ExerciseItem(
      title: "Overhead Press",
      description: "Omuz kütlesi ve genel güç.",
      tags: ["Omuz", "Barbell"],
      imageUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&q=80&w=2069",
      steps: ["Barı göğüs hizasında tutun.", "Başınızı hafif geri çekerek barı yukarı itin.", "Tepe noktada kollar düz olsun.", "Kontrollü indirin."],
    ),
    ExerciseItem(
      title: "Lateral Raise",
      description: "Yan omuzları genişletmek için.",
      tags: ["Omuz", "Dumbbell"],
      imageUrl: "https://images.unsplash.com/photo-1541600383005-565c949cf777?auto=format&fit=crop&q=80&w=2070",
      steps: ["Dumbbell'ları yanlarda tutun.", "Dirsekleri hafif bükerek kolları yana açın.", "Omuz hizasına kadar kaldırın.", "Yavaşça indirin."],
    ),
    ExerciseItem(
      title: "Face Pull",
      description: "Arka omuz ve postür düzeltici.",
      tags: ["Omuz", "Kablo"],
      imageUrl: "https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&q=80&w=2074",
      steps: ["Halatı göz hizasında ayarlayın.", "Halatı yüzünüze doğru çekin.", "Dirsekleri dışarı ve geriye açın.", "Kontrollü bırakın."],
    ),

    // --- KOL ---
    ExerciseItem(
      title: "Barbell Curl",
      description: "Biceps (Pazu) kütlesi için.",
      tags: ["Kol", "Barbell"],
      imageUrl: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&q=80&w=2070",
      steps: ["Barı omuz genişliğinde tutun.", "Dirsekleri vücuda sabitleyin.", "Barı göğsünüze doğru kaldırın.", "Yavaşça indirin."],
    ),
    ExerciseItem(
      title: "Tricep Pushdown",
      description: "Arka kol kaslarını izole eder.",
      tags: ["Kol", "Kablo"],
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2070",
      steps: ["Halatı veya barı üstten tutun.", "Dirsekleri vücuda yapıştırın.", "Aşağı doğru tam kilitlenene kadar itin.", "Yavaşça yukarı bırakın."],
    ),
    ExerciseItem(
      title: "Hammer Curl",
      description: "Biceps ve ön kol gelişimi.",
      tags: ["Kol", "Dumbbell"],
      imageUrl: "https://images.unsplash.com/photo-1581009137042-c552e485697a?auto=format&fit=crop&q=80&w=2070",
      steps: ["Dumbbell'ları avuç içleri birbirine bakacak şekilde tutun.", "Dirsekleri oynatmadan kaldırın.", "İndirirken kontrolü bırakmayın."],
    ),

    // --- KARIN & CARDIO ---
    ExerciseItem(
      title: "Plank",
      description: "Core bölgesi dayanıklılığı.",
      tags: ["Karın", "Vücut Ağırlığı"],
      imageUrl: "https://plus.unsplash.com/premium_photo-1672046218138-085e7d58356d?auto=format&fit=crop&q=80&w=2070",
      steps: ["Dirsekler üzerinde şınav pozisyonu alın.", "Vücut düz bir çizgi olmalı.", "Karnı sıkın, belin çukurlaşmasını önleyin.", "Süre bitene kadar bekleyin."],
    ),
    ExerciseItem(
      title: "Crunch",
      description: "Üst karın kaslarını hedefler.",
      tags: ["Karın", "Vücut Ağırlığı"],
      imageUrl: "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?auto=format&fit=crop&q=80&w=2069",
      steps: ["Sırt üstü yatın, dizleri bükün.", "Elleri başın arkasına koyun.", "Kürek kemiklerini yerden kaldırarak öne bükülün.", "Yavaşça geri yatın."],
    ),
    ExerciseItem(
      title: "Koşu Bandı",
      description: "Kardiyovasküler dayanıklılık ve yağ yakımı.",
      tags: ["Cardio", "Makine"],
      imageUrl: "https://images.unsplash.com/photo-1576678927484-cc907957088c?auto=format&fit=crop&q=80&w=2070",
      steps: ["Bandın üzerine çıkın ve hızı ayarlayın.", "Dik durun ve düzenli nefes alın.", "İstediğiniz süre boyunca tempolu yürüyün veya koşun."],
    ),
  ];

  final TextEditingController _setsController = TextEditingController(text: "3");
  final TextEditingController _repsController = TextEditingController(text: "12");

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  // --- ADD DIALOG (POP-UP) ---
  void _showAddToWorkoutDialog(BuildContext context, ExerciseItem exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      exercise.imageUrl,
                      width: 60, height: 60, fit: BoxFit.cover,
                      // Resim yüklenemezse mavi ikon
                      errorBuilder: (c,e,s) => Container(width:60, height:60, color:Colors.grey, child: const Icon(Icons.fitness_center, color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(exercise.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Set", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Tekrar", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Mavi Buton
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    final subtitle = "${_setsController.text} x ${_repsController.text}";
                    ref.read(taskProvider.notifier).addTask(exercise.title, subtitle);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${exercise.title} eklendi!"), backgroundColor: Colors.green));
                  },
                  child: const Text("Listeme Ekle", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, ExerciseItem exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailScreen(
          exercise: exercise,
          onAddPressed: () => _showAddToWorkoutDialog(context, exercise),
        ),
      ),
    );
  }

  // --- FILTER LOGIC ---
  List<ExerciseItem> get _filteredExercises {
    return _allExercises.where((exercise) {
      bool categoryMatches = _selectedCategory == "Tümü" || exercise.tags.contains(_selectedCategory);
      bool equipmentMatches = _selectedEquipment == "Tümü" || exercise.tags.contains(_selectedEquipment);
      return categoryMatches && equipmentMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredExercises;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // Mavi AppBar
        backgroundColor: Colors.blue,
        title: const Text("Egzersiz Kütüphanesi", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
<<<<<<< HEAD
            color: Colors.grey[200],
            child: DropdownButtonFormField<String>(
              initialValue: _selectedBodyPart,
              decoration: const InputDecoration(
                labelText: 'Filter by Body Part',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Exercises'),
                ),
                ..._availableBodyParts.map((part) => DropdownMenuItem(
                      value: part,
                      child: Text(part.toUpperCase()),
                    )),
=======
            color: Colors.white,
            child: Column(
              children: [
                _buildRealFilterDropdown("Kasa Göre Filtrele", _selectedCategory, _categories, (val) => setState(() => _selectedCategory = val!)),
                const SizedBox(height: 12),
                _buildRealFilterDropdown("Ekipmana Göre Filtrele", _selectedEquipment, _equipments, (val) => setState(() => _selectedEquipment = val!)),
>>>>>>> 663c45709b78ccf4e34e1595676a603f9846e520
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(context, displayList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value, isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              onChanged: onChanged,
              items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExerciseItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetail(context, item),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  // Mavi tonlu yuvarlak arka plan
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(
                      item.imageUrl, fit: BoxFit.cover,
                      // Resim yüklenemezse mavi ikon
                      errorBuilder: (c,e,s) => const Icon(Icons.fitness_center, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(item.description, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _showAddToWorkoutDialog(context, item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    // Mavi "Ekle" butonu
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: const Text("Ekle", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- DETAIL SCREEN (MAVİ TEMA) ---
class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseItem exercise;
  final VoidCallback onAddPressed;

  const ExerciseDetailScreen({super.key, required this.exercise, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false, pinned: true,
            // Mavi SliverAppBar
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(exercise.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              background: Image.network(
                exercise.imageUrl, fit: BoxFit.cover,
                // Resim yüklenemezse mavi arka planlı placeholder
                errorBuilder: (c,e,s) => Container(color: Colors.blue, child: const Icon(Icons.fitness_center, size: 80, color: Colors.white54)),
              ),
            ),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: exercise.tags.map((tag) => Chip(
                        // Mavi etiketler (Chip)
                        label: Text(tag, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                        backgroundColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.blue.shade100)),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text("Hakkında", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(exercise.description, style: TextStyle(color: Colors.grey[700], height: 1.5)),
                    const SizedBox(height: 24),
                    const Text("Nasıl Yapılır?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...exercise.steps.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24, height: 24, alignment: Alignment.center,
                              // Mavi adım numaraları
                              decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                              child: Text("${entry.key + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 14, height: 1.4))),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))]),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            // Mavi alt buton
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: onAddPressed,
            child: const Text("Antrenman Listeme Ekle", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}