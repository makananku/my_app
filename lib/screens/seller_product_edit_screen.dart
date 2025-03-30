// screens/seller_edit_product_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellerEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const SellerEditProductScreen({super.key, this.product});

  @override
  _SellerEditProductScreenState createState() => _SellerEditProductScreenState();
}

class _SellerEditProductScreenState extends State<SellerEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?['title'] ?? '');
    _priceController = TextEditingController(text: widget.product?['price'] ?? '');
    _timeController = TextEditingController(text: widget.product?['time'] ?? '');
    _descriptionController = TextEditingController(text: widget.product?['subtitle'] ?? '');
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _imageFile != null 
                      ? FileImage(_imageFile!) 
                      : widget.product?['imgUrl'] != null
                          ? AssetImage(widget.product!['imgUrl']) as ImageProvider
                          : null,
                  child: _imageFile == null && widget.product?['imgUrl'] == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Preparation Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter preparation time';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // Simpan produk ke database atau state management
      Navigator.pop(context, {
        'title': _nameController.text,
        'subtitle': _descriptionController.text,
        'price': _priceController.text,
        'time': _timeController.text,
        'imgUrl': _imageFile?.path ?? widget.product?['imgUrl'],
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}