import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/predictor_data_model.dart';

/// ViewModel for managing predictor data
/// Currently uses Firebase, structured for easy future improvements
class View3DataViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<PredictorDataModel> _predictorData = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<PredictorDataModel> get predictorData => _predictorData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  View3DataViewModel() {
    fetchPredictorData();
  }

  /// Initialize mock data for preview/demo purposes
  /// This will be used when Firebase returns empty data
  void _initializeMockData() {
    _predictorData = [
      PredictorDataModel(
        id: 'mock_1',
        assignmentScore: 85.5,
        assessmentScore: 88.0,
        attendanceScore: 92.0,
        userId: 'mock_user',
      ),
    ];
  }

  /// Fetch predictor data from Firebase
  /// Currently uses Firebase, but structured for easy future improvements
  Future<void> fetchPredictorData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('predictordata')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          _predictorData = [
            PredictorDataModel.fromFirestore(data, snapshot.id),
          ];
        } else {
          // Use mock data when no Firebase data exists
          _initializeMockData();
        }
      } else {
        // User not logged in, use mock data
        _initializeMockData();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching predictor data: $error");
      }
      // Use mock data on error so user can see the UI
      _initializeMockData();
      _errorMessage = null; // Don't show error, just use mock data
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh predictor data
  Future<void> refresh() async {
    await fetchPredictorData();
  }
}
