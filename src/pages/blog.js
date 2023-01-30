import * as React from "react"
import { Link, graphql } from "gatsby"
import Layout from "../components/layout"
import Seo from "../components/SEO"
// import agua from "./agua"

const Blog = ({ data }) => {
    return (
        <div>
            <Layout>
                <Seo title={"Blog"} />
                <h2>Últimos posts</h2>
                {data.allMarkdownRemark.edges.map(({ node }) => (
                    <div key={node.id} style={{ marginTop: "2em" }}>
                        <Link to={`/blog/` + node.frontmatter.slug} style={{ color: "#000" }}>
                            <h4>
                                {node.frontmatter.title}<br />
                                <span style={{ fontSize: "0.8em" }}>{node.frontmatter.date}</span>
                            </h4>
                            <p>{node.excerpt}</p>
                        </Link>
                        <hr />
                    </div>
                ))}
            </Layout>
        </div>
    )
}
export default Blog;
export const query = graphql`
    query pageDGithubmolxGithubIosrcpagesblogJs741688360 {
        allMarkdownRemark(sort: {frontmatter: {date: DESC}}) {
        totalCount
        edges {
            node {
            id
            frontmatter {
                slug
                title
                date(formatString: "DD/MM/YYYY")
            }
            fields {
                slug
            }
            excerpt
            }
        }
        }
    }
`
