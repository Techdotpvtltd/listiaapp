// Project: 	   RenewFitness
// File:    	   reference_model
// Path:    	   lib/web_services/reference_model.dart
// Author:       Ali Akbar
// Date:        12-10-24 17:34:39 -- Saturday
// Description:

class FirePathReference {
  final FIREReferenceType type;
  final dynamic path;

  FirePathReference({required this.type, this.path});
}

enum FIREReferenceType { collection, doc }
