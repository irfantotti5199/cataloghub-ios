
import type { Request, Response } from "express";
import { ProductService } from "../services/productService.js";

export class ProductController {

    private productService: ProductService;

    constructor(productService: ProductService) {
        this.productService = productService;
    }

    getProducts = async (_req: Request, res: Response) => {
        try {
            const products = await this.productService.getProducts();

            res.status(200).json(products);

        } catch (error) {
            console.error("Error fetching products:", error);

            res.status(500).json({
                status: "error",
                message: "Unable to fetch products"
            });
        }
    };

	
getFeaturedProducts = async (_req: Request, res: Response) => {
    try {
        const products = await this.productService.getFeaturedProducts();

        res.status(200).json(products);

    } catch (error) {
        console.error("Error fetching featured products:", error);

        res.status(500).json({
            status: "error",
            message: "Unable to fetch featured products"
        });
    }
};



getCategories = async (_req: Request, res: Response) => {
    try {
        const categories = await this.productService.getCategories();

        res.status(200).json(categories);

    } catch (error) {
        console.error("Error fetching categories:", error);

        res.status(500).json({
            status: "error",
            message: "Unable to fetch categories"
        });
    }
};


getProductsByCategory = async (req: Request, res: Response) => {
    try {
        const category = req.params.category;

        if (typeof category !== "string" || !category.trim()) {
            res.status(400).json({
                status: "error",
                message: "Invalid category"
            });
            return;
        }

        const products =
            await this.productService.getProductsByCategory(category);

        res.status(200).json(products);

    } catch (error) {
        console.error("Error fetching category products:", error);

        res.status(500).json({
            status: "error",
            message: "Unable to fetch category products"
        });
    }
};






searchProducts = async (req: Request, res: Response) => {
    try {
        const query = req.query.q;

        if (typeof query !== "string" || !query.trim()) {
            res.status(400).json({
                status: "error",
                message: "Search query is required"
            });
            return;
        }

        const products =
            await this.productService.searchProducts(query);

        res.status(200).json(products);

    } catch (error) {
        console.error("Error searching products:", error);

        res.status(500).json({
            status: "error",
            message: "Unable to search products"
        });
    }
};



getProductById = async (req: Request, res: Response) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id <= 0) {
            res.status(400).json({
                status: "error",
                message: "Invalid product ID"
            });
            return;
        }

        const product = await this.productService.getProductById(id);

        res.status(200).json(product);

    } catch (error) {
        console.error("Error fetching product:", error);

        if (error instanceof Error && error.message === "Product not found") {
            res.status(404).json({
                status: "error",
                message: "Product not found"
            });
            return;
        }

        res.status(500).json({
            status: "error",
            message: "Unable to fetch product"
        });
    }
};




}
