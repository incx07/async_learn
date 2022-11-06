import Main from "@/pages/Main";
import PostsPage from "@/pages/PostsPage";
import PostsPageWithStore from "@/pages/PostsPageWithStore";
import PostPage from "@/pages/PostPage";
import About from "@/pages/About";
import { createRouter, createWebHistory } from "vue-router";

const routes = [
    {
        path: '/',
        component: Main
    },
    {
        path: '/posts',
        component: PostsPage,
    },
    {
        path: '/about',
        component: About,
    },
    {
        path: '/posts/:id',
        component: PostPage,
    },
    {
        path: '/store',
        component: PostsPageWithStore,
    },
]

const router = createRouter(
    {
        routes,
        history: createWebHistory(process.env.BASE_URL)
    }
)

export default router;
