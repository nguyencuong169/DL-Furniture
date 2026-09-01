using DLFurniture.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<NewsItem> News { get; set; } = null!;
    public DbSet<NewsCategory> NewsCategories { get; set; } = null!;
    public DbSet<GalleryCategory> GalleryCategories { get; set; } = null!;
    public DbSet<GalleryItem> GalleryItems { get; set; } = null!;
    public DbSet<Project> Projects { get; set; } = null!;
    public DbSet<BookingRequest> BookingRequests { get; set; } = null!;
    public DbSet<Testimonial> Testimonials { get; set; } = null!;
    public DbSet<TeamMember> TeamMembers { get; set; } = null!;
    public DbSet<ServiceItem> Services { get; set; } = null!;
    public DbSet<Menu> Menus { get; set; } = null!;
    public DbSet<Category> Categories { get; set; } = null!;
    public DbSet<Product> Products { get; set; } = null!;
    public DbSet<ProductImage> ProductImages { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure News table
        modelBuilder.Entity<NewsItem>()
            .ToTable("news")
            .HasKey(n => n.Id);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsId)
            .HasColumnName("news_id")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Titles)
            .HasColumnName("title")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Summary)
            .HasColumnName("summary");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Content)
            .HasColumnName("content");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsImage)
            .HasColumnName("news_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.ViewCount)
            .HasColumnName("view_count")
            .HasDefaultValue(0L);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.NewsCategoryId)
            .HasColumnName("news_category_id");

        modelBuilder.Entity<NewsItem>()
            .HasOne(n => n.NewsCategory)
            .WithMany(c => c.NewsItems)
            .HasForeignKey(n => n.NewsCategoryId)
            .OnDelete(DeleteBehavior.Restrict);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Tags)
            .HasColumnName("tags")
            .HasMaxLength(2048);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);


        modelBuilder.Entity<NewsItem>()
            .Property(n => n.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.CreatedDate)
            .HasColumnName("created_date");

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsItem>()
            .Property(n => n.UpdatedDate)
            .HasColumnName("updated_date");

        modelBuilder.Entity<NewsCategory>()
            .ToTable("news_categories")
            .HasKey(c => c.Id);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Id)
            .HasColumnName("id");

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.Slug)
            .HasColumnName("slug")
            .HasMaxLength(255);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.DisplayOrder)
            .HasColumnName("display_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<NewsCategory>()
            .Property(c => c.IsActive)
            .HasColumnName("is_active")
            .HasDefaultValue(true);

        modelBuilder.Entity<NewsCategory>()
            .HasIndex(c => c.Slug)
            .IsUnique();

        modelBuilder.Entity<GalleryCategory>(entity =>
        {
            entity.ToTable("gallery_categories");
            entity.HasKey(category => category.Id);
            entity.Property(category => category.Id).HasColumnName("id");
            entity.Property(category => category.Name).HasColumnName("name").HasMaxLength(255);
            entity.Property(category => category.Slug).HasColumnName("slug").HasMaxLength(100);
            entity.Property(category => category.DisplayOrder).HasColumnName("display_order").HasDefaultValue(0);
            entity.Property(category => category.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.HasIndex(category => category.Slug).IsUnique();
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.ToTable("projects");
            entity.HasKey(project => project.Id);
            entity.Property(project => project.Id).HasColumnName("id");
            entity.Property(project => project.Title).HasColumnName("title").HasMaxLength(255);
        });

        modelBuilder.Entity<GalleryItem>(entity =>
        {
            entity.ToTable("gallery_items", table =>
                table.HasCheckConstraint("CK_gallery_items_media_type", "[media_type] IN ('image', 'video')"));
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Id).HasColumnName("id");
            entity.Property(item => item.CategoryId).HasColumnName("category_id");
            entity.Property(item => item.ProjectId).HasColumnName("project_id");
            entity.Property(item => item.Title).HasColumnName("title").HasMaxLength(255);
            entity.Property(item => item.Description).HasColumnName("description");
            entity.Property(item => item.MediaType).HasColumnName("media_type").HasMaxLength(20);
            entity.Property(item => item.MediaUrl).HasColumnName("media_url").HasMaxLength(1024);
            entity.Property(item => item.ThumbnailUrl).HasColumnName("thumbnail_url").HasMaxLength(1024);
            entity.Property(item => item.AltText).HasColumnName("alt_text").HasMaxLength(500);
            entity.Property(item => item.Provider).HasColumnName("provider").HasMaxLength(30).HasDefaultValue("local");
            entity.Property(item => item.Duration).HasColumnName("duration").HasMaxLength(20);
            entity.Property(item => item.IsFeatured).HasColumnName("is_featured").HasDefaultValue(false);
            entity.Property(item => item.DisplayOrder).HasColumnName("display_order").HasDefaultValue(0);
            entity.Property(item => item.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.Property(item => item.CreatedAt).HasColumnName("created_at").HasDefaultValueSql("SYSUTCDATETIME()");
            entity.Property(item => item.UpdatedAt).HasColumnName("updated_at").HasDefaultValueSql("SYSUTCDATETIME()");
            entity.HasOne(item => item.Category)
                .WithMany(category => category.GalleryItems)
                .HasForeignKey(item => item.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(item => item.Project)
                .WithMany(project => project.GalleryItems)
                .HasForeignKey(item => item.ProjectId)
                .OnDelete(DeleteBehavior.SetNull);
            entity.HasIndex(item => new { item.IsActive, item.MediaType, item.DisplayOrder });
            entity.HasIndex(item => new { item.IsActive, item.MediaType, item.UpdatedAt });
            entity.HasIndex(item => item.ProjectId);
        });

        modelBuilder.Entity<BookingRequest>(entity =>
        {
            entity.ToTable("booking_requests");
            entity.HasKey(request => request.Id);
            entity.Property(request => request.Id).HasColumnName("id");
            entity.Property(request => request.FullName).HasColumnName("full_name").HasMaxLength(255);
            entity.Property(request => request.Email).HasColumnName("email").HasMaxLength(255);
            entity.Property(request => request.Phone).HasColumnName("phone").HasMaxLength(50);
            entity.Property(request => request.Message).HasColumnName("message");
            entity.Property(request => request.Source)
                .HasColumnName("source")
                .HasMaxLength(100)
                .HasDefaultValue("consultation_form");
            entity.Property(request => request.Status)
                .HasColumnName("status")
                .HasMaxLength(50)
                .HasDefaultValue("pending");
            entity.Property(request => request.CreatedAt)
                .HasColumnName("created_at")
                .HasDefaultValueSql("GETDATE()");
            entity.Property(request => request.UpdatedAt)
                .HasColumnName("updated_at")
                .HasDefaultValueSql("GETDATE()");
        });

        // Configure Testimonials table
        modelBuilder.Entity<Testimonial>()
            .ToTable("testimonials")
            .HasKey(t => t.Id);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CustomerName)
            .HasColumnName("customer_name")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Location)
            .HasColumnName("location")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Content)
            .HasColumnName("content");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Rating)
            .HasColumnName("rating")
            .HasDefaultValue(5);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Testimonial>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");

        // Configure TeamMembers table
        modelBuilder.Entity<TeamMember>()
            .ToTable("team_members")
            .HasKey(t => t.Id);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Id)
            .HasColumnName("id");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FullName)
            .HasColumnName("full_name")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Role)
            .HasColumnName("role")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.AvatarImage)
            .HasColumnName("avatar_image")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Email)
            .HasColumnName("email")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.FacebookUrl)
            .HasColumnName("facebook_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.TwitterUrl)
            .HasColumnName("twitter_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.InstagramUrl)
            .HasColumnName("instagram_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.PinterestUrl)
            .HasColumnName("pinterest_url")
            .HasMaxLength(1024);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<TeamMember>()
            .Property(t => t.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");

        // Configure Services table
        modelBuilder.Entity<ServiceItem>()
            .ToTable("services")
            .HasKey(s => s.Id);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Id)
            .HasColumnName("id");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Name)
            .HasColumnName("name")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Description)
            .HasColumnName("description");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Image)
            .HasColumnName("image")
            .HasMaxLength(1024);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Category)
            .HasColumnName("category")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<ServiceItem>()
            .Property(s => s.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<ServiceItem>()
                    .Property(s => s.UpdatedDate)
                    .HasColumnName("updated_date")
                    .HasColumnType("datetimeoffset");

        // Configure Menus table
        modelBuilder.Entity<Menu>()
            .ToTable("menus")
            .HasKey(m => m.Id);

        modelBuilder.Entity<Menu>()
            .Property(m => m.Id)
            .HasColumnName("id");

        modelBuilder.Entity<Menu>()
            .Property(m => m.ParentId)
            .HasColumnName("parent_id");

        modelBuilder.Entity<Menu>()
            .Property(m => m.Label)
            .HasColumnName("label")
            .HasMaxLength(255);

        modelBuilder.Entity<Menu>()
            .Property(m => m.Url)
            .HasColumnName("url")
            .HasMaxLength(1024);

        modelBuilder.Entity<Menu>()
            .Property(m => m.Location)
            .HasColumnName("location")
            .HasMaxLength(20)
            .HasDefaultValue("primary");

        modelBuilder.Entity<Menu>()
            .Property(m => m.SortOrder)
            .HasColumnName("sort_order")
            .HasDefaultValue(0);

        modelBuilder.Entity<Menu>()
            .Property(m => m.IsConsultation)
            .HasColumnName("is_consultation")
            .HasDefaultValue(false);

        modelBuilder.Entity<Menu>()
            .Property(m => m.IsActive)
            .HasColumnName("is_active")
            .HasDefaultValue(true);

        modelBuilder.Entity<Menu>()
            .Property(m => m.Hidden)
            .HasColumnName("hidden")
            .HasDefaultValue(false);

        modelBuilder.Entity<Menu>()
            .Property(m => m.DelFlag)
            .HasColumnName("del_flag")
            .HasDefaultValue(false);

        modelBuilder.Entity<Menu>()
            .Property(m => m.CreatedUser)
            .HasColumnName("created_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Menu>()
            .Property(m => m.CreatedDate)
            .HasColumnName("created_date")
            .HasColumnType("datetimeoffset");

        modelBuilder.Entity<Menu>()
            .Property(m => m.UpdatedUser)
            .HasColumnName("updated_user")
            .HasMaxLength(255);

        modelBuilder.Entity<Menu>()
            .Property(m => m.UpdatedDate)
            .HasColumnName("updated_date")
            .HasColumnType("datetimeoffset");

        // Configure Categories table
        modelBuilder.Entity<Category>(entity =>
        {
            entity.ToTable("categories");
            entity.HasKey(category => category.Id);
            entity.Property(category => category.Id).HasColumnName("id");
            entity.Property(category => category.Name).HasColumnName("name").HasMaxLength(255);
            entity.Property(category => category.Slug).HasColumnName("slug").HasMaxLength(255);
            entity.Property(category => category.ParentId).HasColumnName("parent_id");
            entity.Property(category => category.Description).HasColumnName("description");
            entity.Property(category => category.ImageUrl).HasColumnName("image_url").HasMaxLength(1024);
            entity.Property(category => category.ImageAlt).HasColumnName("image_alt").HasMaxLength(255);
            entity.Property(category => category.DisplayOrder).HasColumnName("display_order").HasDefaultValue(0);
            entity.Property(category => category.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.Property(category => category.CreatedAt)
                .HasColumnName("created_at")
                .HasDefaultValueSql("SYSUTCDATETIME()");
            entity.Property(category => category.UpdatedAt)
                .HasColumnName("updated_at")
                .HasDefaultValueSql("SYSUTCDATETIME()");
            entity.HasIndex(category => category.Slug).IsUnique();
        });

        // Configure Products table
        modelBuilder.Entity<Product>(entity =>
        {
            entity.ToTable("products");
            entity.HasKey(product => product.Id);
            entity.Property(product => product.Id).HasColumnName("id");
            entity.Property(product => product.CategoryId).HasColumnName("category_id");
            entity.Property(product => product.Sku).HasColumnName("sku").HasMaxLength(100);
            entity.Property(product => product.Slug).HasColumnName("slug").HasMaxLength(255);
            entity.Property(product => product.Name).HasColumnName("name").HasMaxLength(255);
            entity.Property(product => product.Summary).HasColumnName("summary");
            entity.Property(product => product.Description).HasColumnName("description");
            entity.Property(product => product.Price).HasColumnName("price").HasColumnType("decimal(18,2)");
            entity.Property(product => product.Currency).HasColumnName("currency").HasMaxLength(10).HasDefaultValue("VND");
            entity.Property(product => product.MainImage).HasColumnName("main_image").HasMaxLength(1024);
            entity.Property(product => product.IsActive).HasColumnName("is_active").HasDefaultValue(true);
            entity.Property(product => product.Hidden).HasColumnName("hidden").HasDefaultValue(false);
            entity.Property(product => product.CreatedAt)
                .HasColumnName("created_at")
                .HasDefaultValueSql("SYSUTCDATETIME()");
            entity.Property(product => product.UpdatedAt)
                .HasColumnName("updated_at")
                .HasDefaultValueSql("SYSUTCDATETIME()");
            entity.HasIndex(product => product.Slug).IsUnique();
            entity.HasIndex(product => product.Sku);
            entity.HasIndex(product => product.CategoryId);
            entity.HasOne(product => product.Category)
                .WithMany(category => category.Products)
                .HasForeignKey(product => product.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // Configure ProductImages table
        modelBuilder.Entity<ProductImage>(entity =>
        {
            entity.ToTable("product_images");
            entity.HasKey(image => image.Id);
            entity.Property(image => image.Id).HasColumnName("id");
            entity.Property(image => image.ProductId).HasColumnName("product_id");
            entity.Property(image => image.ImageUrl).HasColumnName("image_url").HasMaxLength(1024);
            entity.Property(image => image.Caption).HasColumnName("caption").HasMaxLength(255);
            entity.Property(image => image.SortOrder).HasColumnName("sort_order").HasDefaultValue(0);
            entity.Property(image => image.CreatedAt)
                .HasColumnName("created_at")
                .HasDefaultValueSql("SYSUTCDATETIME()");
            entity.HasOne(image => image.Product)
                .WithMany(product => product.ProductImages)
                .HasForeignKey(image => image.ProductId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasIndex(image => image.ProductId);
        });
    }
}
