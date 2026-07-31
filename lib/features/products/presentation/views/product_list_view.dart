import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../views/product_detail_view.dart';
import '../../../cart/presentation/views/cart_view.dart'; // Sepet görünümü importu
import '../../../pharmacy/presentation/views/pharmacy_list_view.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eczane Ürünleri'),
        actions: [
          // 1. Eczaneler ve Konum Ekranına Giden Buton
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PharmacyListView(),
                ),
              );
            },
          ),
          // 2. Sepet İkonu
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama Çubuğu Alanı
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (query) {
                if (query.trim().isEmpty) {
                  // Arama kutusu silindiyse tüm ürünleri tekrar getir
                  BlocProvider.of<ProductBloc>(context).add(FetchProductsEvent());
                } else {
                  // Doluysa arama yapmaya devam et
                  BlocProvider.of<ProductBloc>(context)
                      .add(SearchProductsEvent(query: query));
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductInitial) {
                  BlocProvider.of<ProductBloc>(context).add(FetchProductsEvent());
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('Hiç ürün bulunamadı.'));
                  }
                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services, color: Colors.blue),
                          title: Text(product.name),
                          subtitle: Text('${product.price} ₺'),
                          trailing: Text('Stok: ${product.stock}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailView(product: product),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ProductError) {
                  return Center(child: Text('Hata: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}