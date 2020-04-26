module.exports = {
    siteMetadata: {
        title: `Sobre`,
        titleTemplate: "%s - Alan Mól",
        siteUrl: `http://alanmol.com.br`,
        url: "http://alanmol.com.br",
        image: "/img/alanmol.jpg",
        description: `Site pessoal de Alan Mól`,
        twitterUsername: "molx",
        type: "website",
    },
    plugins: [
        {
            resolve: `gatsby-plugin-typography`,
            options: {
                pathToConfigModule: `src/utils/typography`,
            },
        },
        {
            resolve: `gatsby-source-filesystem`,
            options: {
                name: `data`,
                path: `${__dirname}/src/data/`,
            },
        },
        {
            resolve: `gatsby-source-filesystem`,
            options: {
                name: `blog`,
                path: `${__dirname}/src/blog`,
            },
        },
        `gatsby-transformer-csv`,
        {
            resolve: `gatsby-plugin-google-analytics`,
            options: {
                trackingId: "UA-60942909-1",
            },
        },
        `gatsby-plugin-react-helmet`,
        `gatsby-transformer-remark`,
        "gatsby-plugin-slug",
        `gatsby-plugin-sharp`,
        {
            resolve: `gatsby-transformer-remark`,
            options: {
                plugins: [
                    {
                        resolve: `gatsby-remark-images`,
                        options: {
                            maxWidth: 800,
                        },
                    },
                ],
            },
        },
        {
            resolve: `gatsby-plugin-manifest`,
            options: {
                name: `Alan Mól`,
                short_name: `Alan Mól`,
                start_url: `/`,
                background_color: `#fcfffc`,
                theme_color: `#fcfffc`,
                display: `standalone`,
                icon: `static/img/favicon.png`,
            },
        },
        `gatsby-plugin-offline`,
    ],
}
