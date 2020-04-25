const path = require(`path`)
const { createFilePath } = require(`gatsby-source-filesystem`)

/* exports.onCreateNode = ({ node, getNode, actions }) => {
    const { createNodeField } = actions
    if (node.internal.type === `MarkdownRemark`) {
        const slug = createFilePath({ node, getNode, basePath: `blog` })
        createNodeField({
            node,
            name: `slug`,
            value: `/blog` + slug,
        })
    }
} */
exports.createPages = async ({ graphql, actions }) => {
    const { createPage } = actions
    const result = await graphql(`
        query {
            allMarkdownRemark {
                edges {
                    node {                        
                        fields {
                            slug
                        }
                    }
                }
            }
        }
    `)
    result.data.allMarkdownRemark.edges.forEach(({ node }) => {        
        const blogPostPath = `/blog` + node.fields.slug
        createPage({
            path: blogPostPath,
            component: path.resolve(`./src/templates/blog-post.js`),
            context: {
                slug: node.fields.slug,
                postPath: blogPostPath
            },
        })
    })
}
