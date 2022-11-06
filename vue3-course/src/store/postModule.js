import axios from "axios";

export const postModule = {
    state: () => ({
        posts: [],
        isPostsLoadind: false,
        selectedSort: '',
        searchQuery: '',
        page: 1,
        limit: 10,
        totalPages: 0,
        sortOptions: [
            {value: 'title', name: 'by title'},
            {value: 'body', name: 'by body'},
            {value: 'id', name: 'by id'},
        ]
    }),
    getters: {
        sortedPosts(state) {
            return [...state.posts].sort((post1, post2) => {
                if (state.selectedSort === 'id') {
                    return post1[state.selectedSort] - post2[state.selectedSort]
                } else {
                    return post1[state.selectedSort]?.localeCompare(post2[state.selectedSort])
                }
            })
        },
        sortedAndSearchedPosts(state, getters) {
            return getters.sortedPosts.filter(post => post.title.toLowerCase().includes(state.searchQuery.toLowerCase()))
        }

    },
    mutations: {
        setPosts(state, posts) {
            state.posts = posts;
        },
        setIsPostsLoadind(state, isPostsLoadind) {
            state.isPostsLoadind = isPostsLoadind;
        },
        setSelectedSort(state, selectedSort) {
            state.selectedSort = selectedSort;
        },
        setSearchQuery(state, searchQuery) {
            state.searchQuery = searchQuery;
        },
        setPage(state, page) {
            state.page = page;
        }, 
        setTotalPages(state, totalPages) {
            state.totalPages = totalPages;
        }, 
    },
    actions: {
        async fetchPosts({state, commit}) {
            commit('setIsPostsLoadind', true);
            try {
                const responce = await axios.get('https://jsonplaceholder.typicode.com/posts', {
                    params: {
                        _page: state.page,
                        _limit: state.limit
                    }
                });
                commit('setTotalPages', Math.ceil(responce.headers['x-total-count'] / state.limit));
                commit('setPosts', responce.data);
            } catch (error) {
                alert('Error!')
            } finally {
                commit('setIsPostsLoadind', false);
            }
        }, 
        async loadMorePosts({state, commit}) {
            commit('setPage', state.page + 1);
            try {
                const responce = await axios.get('https://jsonplaceholder.typicode.com/posts', {
                    params: {
                        _page: state.page,
                        _limit: state.limit
                    }
                });
                commit('setTotalPages', Math.ceil(responce.headers['x-total-count'] / state.limit));
                commit('setPosts', [...state.posts, ...responce.data]);
            } catch (error) {
                alert('Error!')
            }
        }
    },
    namespaced: true
}
