import 'dart:io';
import 'package:e/screens/seller/seller_dashboard_screen.dart';
import 'package:e/services/firestore_service.dart';
import 'package:e/services/storage_service.dart';
import 'package:e/utils/constants.dart';
import 'package:e/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductUploadScreen extends StatefulWidget {
  static const String routeName = '/product-upload';

  const ProductUploadScreen({super.key});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  String? _selectedCategory;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userData = await _firestoreService.getUserData(user.uid);
          final shopId = userData?['shopId'];
          if (shopId == null) {
            throw Exception('No shop found for this seller');
          }

          final imageUrl =
              await _storageService.uploadProductImage(_imageFile!, shopId);
          await _firestoreService.createProduct(
            shopId: shopId,
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text.trim()),
            category: _selectedCategory!,
            description: _descriptionController.text.trim(),
            imageUrl: imageUrl,
          );

          Navigator.pushReplacementNamed(
              context, SellerDashboardScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product uploaded successfully!'),
              backgroundColor: kPrimaryColor,
            ),
          );
        } else {
          throw Exception('No user logged in');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to upload product: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: kErrorColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Product',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: NetworkImage(kDefaultImageUrl),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: _imageFile == null
                        ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: kPrimaryColor,
                              size: 40,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: kLargePadding),
              // Product Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.label, color: kPrimaryColor),
                ),
                validator: (value) =>
                    Validators.validateName(value, 'product name'),
              ),
              const SizedBox(height: kDefaultPadding),
              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money, color: kPrimaryColor),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validatePrice,
              ),
              const SizedBox(height: kDefaultPadding),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category, color: kPrimaryColor),
                ),
                items: kProductCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: Validators.validateCategory,
              ),
              const SizedBox(height: kDefaultPadding),
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description, color: kPrimaryColor),
                ),
                maxLines: 4,
                validator: Validators.validateDescription,
              ),
              const SizedBox(height: kLargePadding),
              // Upload Button
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _uploadProduct,
                        child: const Text('Upload Product'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
