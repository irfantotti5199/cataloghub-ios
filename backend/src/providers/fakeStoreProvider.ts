
import axios from "axios";
import type { Product } from "../models/Product.js";

const FAKE_STORE_BASE_URL = "https://fakestoreapi.com";

export class FakeStoreProvider {

    async getProducts(): Promise<Product[]> {
        const response = await axios.get<Product[]>(
            `${FAKE_STORE_BASE_URL}/products`
        );

        return response.data;
    }

    async getCategories(): Promise<string[]> {
        const response = await axios.get<string[]>(
            `${FAKE_STORE_BASE_URL}/products/categories`
        );

        return response.data;
    }

    async getProductsByCategory(category: string): Promise<Product[]> {
        const response = await axios.get<Product[]>(
            `${FAKE_STORE_BASE_URL}/products/category/${encodeURIComponent(category)}`
        );

        return response.data;
    }

    async getProductById(id: number): Promise<Product> {
        const response = await axios.get<Product>(
            `${FAKE_STORE_BASE_URL}/products/${id}`
        );

        if (!response.data || !response.data.id) {
            throw new Error("Product not found");
        }

        return response.data;
    }
}
