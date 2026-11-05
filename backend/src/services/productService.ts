
import { FakeStoreProvider } from "../providers/fakeStoreProvider.js";

export class ProductService {

    private provider: FakeStoreProvider;

    constructor(provider: FakeStoreProvider) {
        this.provider = provider;
    }

    async getProducts() {
        return await this.provider.getProducts();
    }

    async getFeaturedProducts() {
        const products = await this.provider.getProducts();

        return [...products]
            .sort((a, b) => b.rating.rate - a.rating.rate)
            .slice(0, 5);
    }

    async getCategories() {
        return await this.provider.getCategories();
    }

    async getProductsByCategory(category: string) {
        return await this.provider.getProductsByCategory(category);
    }

    async searchProducts(query: string) {
        const products = await this.provider.getProducts();

        const searchText = query.trim().toLowerCase();

        if (!searchText) {
            return [];
        }

        return products.filter((product) => {
            return (
                product.title.toLowerCase().includes(searchText) ||
                product.description.toLowerCase().includes(searchText) ||
                product.category.toLowerCase().includes(searchText)
            );
        });
    }

    async getProductById(id: number) {
        return await this.provider.getProductById(id);
    }
}
